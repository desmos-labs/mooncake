import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:mock_web_server/mock_web_server.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/sources/sources.dart';
import 'package:test/test.dart';

class MockTxBuilder extends Mock implements TxBuilder {}

class MockTxSigner extends Mock implements TxSigner {}

class MockTxSender extends Mock implements TxSender {}

class MockHttpClient extends Mock implements http.Client {}

void main() {
  final fee = [StdCoin(denom: Constants.FEE_TOKEN, amount: '10000')];

  MockWebServer lcdServer;
  MockWebServer faucetServer;
  MockHttpClient httpClient;

  ChainSourceImpl chainHelper;

  setUpAll(() {
    lcdServer = MockWebServer();
    lcdServer.start();

    faucetServer = MockWebServer();
    faucetServer.start();
  });

  setUp(() {
    // Clean the dispatcher to avoid cross-testing conflicts
    lcdServer.dispatcher = null;
    faucetServer.dispatcher = null;

    httpClient = MockHttpClient();

    chainHelper = ChainSourceImpl(
      lcdEndpoint: lcdServer.url,
      faucetEndpoint: faucetServer.url,
      httpClient: httpClient,
    );
  });

  group('queryChainRaw', () {
    test('returns null when exception is thrown', () async {
      lcdServer.enqueue(body: null, httpCode: 500);

      final result = await chainHelper.queryChainRaw('/my-endpoint');
      expect(result, isNull);
    });

    test('returns correct value when no exception is thrown', () async {
      final data = {'key': 'value', 'other-value': 'other-key'};
      lcdServer.enqueue(httpCode: 200, body: jsonEncode(data));

      final result = await chainHelper.queryChainRaw('/endpoint');
      expect(result, data);
    });
  });

  group('queryChain', () {
    test('returns null when exception is thrown', () async {
      lcdServer.enqueue(body: null, httpCode: 500);

      final result = await chainHelper.queryChain('/my-endpoint');
      expect(result, isNull);
    });

    test('returns null when wrong body is returned', () async {
      final data = {'height': '0'};
      lcdServer.enqueue(body: jsonEncode(data), httpCode: 200);

      final result = await chainHelper.queryChain('/my-endpoint');
      expect(result, isNull);
    });

    test('returns correct value when no exception is thrown', () async {
      final file = File('test_resources/chain/chain_response.json');
      final contents = file.readAsStringSync();
      lcdServer.enqueue(httpCode: 200, body: contents);

      final result = await chainHelper.queryChain('/endpoint');

      final expected = LcdResponse(height: '0', result: {
        'id': '1',
        'parent_id': '0',
        'message': 'This is a post',
        'created': '2019-12-11T07:57:54.03384Z',
        'last_edited': '0001-01-01T00:00:00Z',
        'allows_comments': false,
        'subspace': '',
        'optional_data': {
          'external_reference': 'dwitter-2019-12-13T08:51:32.262217'
        },
        'creator': 'desmos17573axzcrmq6w5jwx27qlf9d90lcgkfmsrjycg',
        'reactions': [],
        'children': []
      });
      expect(result, expected);
    });
  });

  group('sendTxBackground', () {
    Wallet wallet;

    setUpAll(() {
      final networkInfo = NetworkInfo(
        bech32Hrp: 'desmos',
        lcdUrl: lcdServer.url,
      );
      final mnemonic = [
        'music',
        'swap',
        'repair',
        'fiber',
        'space',
        'cactus',
        'fold',
        'various',
        'identify',
        'ice',
        'grape',
        'negative',
        'category',
        'cupboard',
        'box',
        'village',
        'gallery',
        'letter',
        'electric',
        'vote',
        'praise',
        'sustain',
        'system',
        'soon',
      ];
      wallet = Wallet.derive(
        mnemonic,
        networkInfo,
        derivationPath: "m/44'/852'/0'/0/0",
      );
    });

    test('returns null with empty list of messages', () async {
      // Enqueue an exception cause it shouldn't be called
      lcdServer.enqueue(httpCode: 500, body: null);

      final txData = TxData(messages: [], wallet: wallet, feeAmount: fee);
      final result = await ChainSourceImpl.sendTxBackground(txData);
      expect(result, isNull);
    });

    test('returns correct result with exception', () async {
      lcdServer.enqueue(httpCode: 500, body: null);

      final msgs = [
        MsgCreatePost(
          parentId: '0',
          message: 'message',
          allowsComments: false,
          subspace: 'desmos',
          optionalData: {},
          creator: 'desmos1ywphunh6kg5d33xs07ufjr9mxxcza6rjq4wrzy',
          medias: null,
          poll: null,
        ),
      ];
      final data = TxData(messages: msgs, wallet: wallet, feeAmount: fee);
      final result = await ChainSourceImpl.sendTxBackground(data);
      expect(result.success, isFalse);
    });

    test('throws exception when tx sending is not successful', () async {
      final accountFile = File('test_resources/account/account_response.json');
      final accountContents = accountFile.readAsStringSync();

      final txsFile = File('test_resources/chain/txs_response_success.json');
      final txsContents = txsFile.readAsStringSync();

      final nodeInfoFile = File('test_resources/chain/node_info_response.json');
      final nodeInfoContents = nodeInfoFile.readAsStringSync();

      // ignore: missing_return
      lcdServer.dispatcher = (HttpRequest request) async {
        final url = request.uri.toString();
        if (url.contains('/auth/account')) {
          return MockResponse()
            ..httpCode = 200
            ..body = accountContents;
        } else if (url.contains('/txs')) {
          return MockResponse()
            ..httpCode = 200
            ..body = txsContents;
        } else if (url.contains('/node_info')) {
          return MockResponse()
            ..httpCode = 200
            ..body = nodeInfoContents;
        }
      };

      final msgs = [
        MsgCreatePost(
          parentId: '0',
          message: 'message',
          allowsComments: false,
          subspace: 'desmos',
          optionalData: {},
          creator: 'desmos1ywphunh6kg5d33xs07ufjr9mxxcza6rjq4wrzy',
          medias: null,
          poll: null,
        ),
      ];
      final data = TxData(messages: msgs, wallet: wallet, feeAmount: fee);
      final result = await ChainSourceImpl.sendTxBackground(data);
      expect(result.success, isFalse);
    });
  });

  group('sendTx', () {
    Wallet wallet;

    setUpAll(() {
      final networkInfo =
          NetworkInfo(bech32Hrp: 'desmos', lcdUrl: lcdServer.url);
      final mnemonic = [
        'music',
        'swap',
        'repair',
        'fiber',
        'space',
        'cactus',
        'fold',
        'various',
        'identify',
        'ice',
        'grape',
        'negative',
        'category',
        'cupboard',
        'box',
        'village',
        'gallery',
        'letter',
        'electric',
        'vote',
        'praise',
        'sustain',
        'system',
        'soon',
      ];
      wallet = Wallet.derive(
        mnemonic,
        networkInfo,
        derivationPath: "m/44'/852'/0'/0/0",
      );
    });

    test('does nothing with empty list of messages', () async {
      // Enqueue an exception cause it shouldn't be called
      lcdServer.enqueue(httpCode: 500, body: null);

      final result = await chainHelper.sendTx([], wallet);
      expect(result, isNull);
    });

    test('returns correct result when exception is thrown', () async {
      lcdServer.enqueue(httpCode: 500, body: null);

      final msgs = [
        MsgCreatePost(
          parentId: '0',
          message: 'message',
          allowsComments: false,
          subspace: 'desmos',
          optionalData: {},
          creator: 'desmos1ywphunh6kg5d33xs07ufjr9mxxcza6rjq4wrzy',
          medias: null,
          poll: null,
        ),
      ];
      final result = await chainHelper.sendTx(msgs, wallet);
      expect(result.success, isFalse);
    });

    test('returns correct result when funding is not required', () async {
      final account = CosmosAccount.offline(wallet.bech32Address).copyWith(
        coins: [StdCoin(denom: Constants.FEE_TOKEN, amount: '1000000')],
      );
      final accountResponse = LcdResponse(
        height: '217386',
        result: AccountResponse(
          type: 'cosmos-sdk/Account',
          accountData: account,
        ).toJson(),
      );

      final txsFile = File('test_resources/chain/txs_response_success.json');
      final txsContents = txsFile.readAsStringSync();

      final nodeInfoFile = File('test_resources/chain/node_info_response.json');
      final nodeInfoContents = nodeInfoFile.readAsStringSync();

      // ignore: missing_return
      lcdServer.dispatcher = (HttpRequest request) async {
        final url = request.uri.toString();
        if (url.contains('/auth/accounts')) {
          return MockResponse()
            ..httpCode = 200
            ..body = jsonEncode(accountResponse.toJson());
        } else if (url.contains('/txs')) {
          return MockResponse()
            ..httpCode = 200
            ..body = txsContents;
        } else if (url.contains('/node_info')) {
          return MockResponse()
            ..httpCode = 200
            ..body = nodeInfoContents;
        }
      };

      final msgs = [
        MsgCreatePost(
          parentId: '0',
          message: 'message',
          allowsComments: false,
          subspace: 'desmos',
          optionalData: {},
          creator: 'desmos1ywphunh6kg5d33xs07ufjr9mxxcza6rjq4wrzy',
          medias: null,
          poll: null,
        ),
      ];

      final result = await chainHelper.sendTx(msgs, wallet);
      expect(result.success, isTrue);
      verifyNever(httpClient.post(any));
    });

    test('returns correct result when funding is required', () async {
      final account = CosmosAccount.offline(wallet.bech32Address).copyWith(
        coins: [StdCoin(denom: Constants.FEE_TOKEN, amount: '0')],
      );
      final accountResponse = LcdResponse(
        height: '217386',
        result: AccountResponse(
          type: 'cosmos-sdk/Account',
          accountData: account,
        ).toJson(),
      );

      final txsFile = File('test_resources/chain/txs_response_success.json');
      final txsContents = txsFile.readAsStringSync();

      final nodeInfoFile = File('test_resources/chain/node_info_response.json');
      final nodeInfoContents = nodeInfoFile.readAsStringSync();

      // ignore: missing_return
      lcdServer.dispatcher = (HttpRequest request) async {
        final url = request.uri.toString();
        if (url.contains('/auth/accounts')) {
          return MockResponse()
            ..httpCode = 200
            ..body = jsonEncode(accountResponse.toJson());
        } else if (url.contains('/txs')) {
          return MockResponse()
            ..httpCode = 200
            ..body = txsContents;
        } else if (url.contains('/node_info')) {
          return MockResponse()
            ..httpCode = 200
            ..body = nodeInfoContents;
        }
      };

      final msgs = [
        MsgCreatePost(
          parentId: '0',
          message: 'message',
          allowsComments: false,
          subspace: 'desmos',
          optionalData: {},
          creator: 'desmos1ywphunh6kg5d33xs07ufjr9mxxcza6rjq4wrzy',
          medias: null,
          poll: null,
        ),
      ];

      final result = await chainHelper.sendTx(msgs, wallet);
      expect(result.success, isTrue);
      verify(httpClient.post(
        faucetServer.url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'address': wallet.bech32Address}),
      ));
    });
  });
}
