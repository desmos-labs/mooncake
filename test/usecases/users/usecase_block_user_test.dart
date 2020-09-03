import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/usecases/usecases.dart';

import 'common.dart';

void main() {
  UsersRepository repository;
  BlockUserUseCase blockUserUseCase;

  setUp(() {
    repository = UsersRepositoryMock();
    blockUserUseCase = BlockUserUseCase(usersRepository: repository);
  });

  test('block performs correct calls', () async {
    when(repository.blockUser(any)).thenAnswer((_) => Future.value(null));

    final user = User.fromAddress('address');
    await blockUserUseCase.block(user);

    verify(repository.blockUser(user)).called(1);
  });
}
