import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/usecases/usecases.dart';

import '../../mocks/mocks.dart';
import 'common.dart';

void main() {
  UserRepository repository;
  SaveWalletUseCase saveWalletUseCase;

  setUp(() {
    repository = UserRepositoryMock();
    saveWalletUseCase = SaveWalletUseCase(userRepository: repository);
  });

  group('saveWallet works properly', () {
    test('when no funding is necessary', () async {
      final wallet = MockWallet();
      final mnemonic = 'mnemonic';
      when(repository.saveWallet(mnemonic))
          .thenAnswer((_) => Future.value(wallet));

      await saveWalletUseCase.saveWallet(mnemonic);

      verifyInOrder([
        repository.saveWallet(mnemonic),
      ]);
    });
  });
}
