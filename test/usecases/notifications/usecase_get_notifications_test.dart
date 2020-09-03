import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/usecases/usecases.dart';

import 'common.dart';

void main() {
  NotificationsRepository repository;
  GetNotificationsUseCase getNotificationsUseCase;

  setUp(() {
    repository = NotificationsRepositoryMock();
    getNotificationsUseCase = GetNotificationsUseCase(
      repository: repository,
    );
  });

  test('single performs correct calls', () async {
    final data = [
      TxSuccessfulNotification(date: DateTime.now(), txHash: 'hash-1'),
      TxFailedNotification(date: DateTime.now(), txHash: 'hash-2', error: 'e'),
    ];
    when(repository.getNotifications())
        .thenAnswer((realInvocation) => Future.value(data));

    final result = await getNotificationsUseCase.single();
    expect(result, equals(data));

    verify(repository.getNotifications()).called(1);
  });
}
