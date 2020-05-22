import 'package:dependencies/dependencies.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:graphql/client.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/repositories/repositories.dart';
import 'package:mooncake/sources/sources.dart';
import 'package:sembast/sembast.dart';

class SourcesModule implements Module {
  static const _useLocalEndpoints = false;

  static const _faucetEndpoint = "https://faucet.desmos.network/airdrop";
  static const _ipfsEndpoint = "ipfs.desmos.network";

  static const _lcdUrl = _useLocalEndpoints
      ? "http://10.0.2.2:1317"
      : "http://lcd.morpheus.desmos.network:1317";

  final _networkInfo = NetworkInfo(
    bech32Hrp: "desmos",
    lcdUrl: _lcdUrl,
  );

  final _gqlClient = GraphQLClient(
    link: HttpLink(
      uri: _useLocalEndpoints
          ? "http://10.0.2.2:8080/v1/graphql"
          : "https://gql.morpheus.desmos.network/v1/graphql",
    ).concat(WebSocketLink(
      url: _useLocalEndpoints
          ? "ws://10.0.2.2:8080/v1/graphql"
          : "wss://gql.morpheus.desmos.network/v1/graphql",
    )),
    cache: InMemoryCache(),
  );

  final Database accountDatabase;
  final Database postsDatabase;
  final Database notificationsDatabase;
  final Database blockedUsersDatabase;

  SourcesModule({
    @required this.postsDatabase,
    @required this.accountDatabase,
    @required this.notificationsDatabase,
    @required this.blockedUsersDatabase,
  })  : assert(postsDatabase != null),
        assert(accountDatabase != null),
        assert(notificationsDatabase != null),
        assert(blockedUsersDatabase != null);

  @override
  void configure(Binder binder) {
    binder
      // Chain sources
      ..bindLazySingleton<ChainSource>((injector, params) => ChainSourceImpl(
            lcdEndpoint: _lcdUrl,
          ))
      // User sources
      ..bindLazySingleton<LocalUserSource>(
          (injector, params) => LocalUserSourceImpl(
                networkInfo: _networkInfo,
                database: accountDatabase,
                secureStorage: FlutterSecureStorage(),
              ))
      ..bindLazySingleton<RemoteUserSource>(
          (injector, params) => RemoteUserSourceImpl(
                graphQLClient: _gqlClient,
                faucetEndpoint: _faucetEndpoint,
                chainHelper: injector.get(),
                msgConverter: UserMsgConverter(),
                userSource: injector.get(),
                remoteMediasSource: injector.get(),
              ))
      // Post sources
      ..bindLazySingleton<LocalPostsSource>(
          (injector, params) => LocalPostsSourceImpl(
                database: postsDatabase,
                usersRepository: injector.get(),
              ))
      ..bindLazySingleton<RemotePostsSource>(
        (injector, params) => RemotePostsSourceImpl(
          graphQLClient: _gqlClient,
          chainHelper: injector.get(),
          userSource: injector.get(),
          remoteMediasSource: injector.get(),
          msgConverter: PostsMsgConverter(),
        ),
      )
      // Medias source
      ..bindLazySingleton<RemoteMediasSource>(
          (injector, params) => RemoteMediasSourceImpl(
                ipfsEndpoint: _ipfsEndpoint,
              ))
      // Notifications source
      ..bindLazySingleton<RemoteNotificationsSource>(
          (injector, params) => RemoteNotificationsSourceImpl(
                localUserSource: injector.get(),
              ))
      ..bindLazySingleton<LocalNotificationsSource>(
          (injector, params) => LocalNotificationsSourceImpl(
                database: accountDatabase,
              ))
      // Users source
      ..bindLazySingleton<LocalUsersSource>(
          (injector, params) => LocalUsersSourceImpl(
                database: blockedUsersDatabase,
              ));
  }
}
