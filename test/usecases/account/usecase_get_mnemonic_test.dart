import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/usecases/usecases.dart';

import 'common.dart';

void main() {
  UserRepository repository;
  GetMnemonicUseCase getMnemonicUseCase;

  setUp(() {
    repository = UserRepositoryMock();
    getMnemonicUseCase = GetMnemonicUseCase(userRepository: repository);
  });

  test('get performs correct call', () async {
    final mnemonic = ['first', 'second', 'third'];
    when(repository.getMnemonic('address'))
        .thenAnswer((_) => Future.value(mnemonic));

    final result = await getMnemonicUseCase.get('address');
    expect(result, equals(mnemonic));

    verify(repository.getMnemonic('address')).called(1);
  });
}
