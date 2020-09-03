import 'package:mockito/mockito.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/repositories/notifications/notifications_repository_impl.dart';
import 'package:mooncake/repositories/repositories.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test/test.dart';

class LocalSourceMock extends Mock implements LocalNotificationsSource {}

class RemoteSourceMock extends Mock implements RemoteNotificationsSource {}

void main() {
  LocalSourceMock localSource;

  RemoteSourceMock remoteSource;
  BehaviorSubject<NotificationData> remoteStream;

  NotificationsRepositoryImpl repository;

  setUp(() {
    // Setup local source
    localSource = LocalSourceMock();

    // Setup remote source
    remoteSource = RemoteSourceMock();
    remoteStream = BehaviorSubject<NotificationData>();
    when(remoteSource.notificationsStream)
        .thenAnswer((_) => remoteStream.stream);

    // Setup repository
    repository = NotificationsRepositoryImpl(
      localNotificationsSource: localSource,
      remoteNotificationsSource: remoteSource,
    );
  });

  tearDown(() {
    remoteStream.close();
  });

  test('new remote notifications are stored locally', () async {
    when(localSource.saveNotification(any)).thenAnswer((_) => Future.value());

    final first = TxFailedNotification(
      date: DateTime.now(),
      error: '',
      txHash: '',
    );
    final second = TxSuccessfulNotification(txHash: '', date: DateTime.now());
    remoteStream.add(first);
    remoteStream.add(second);

    await untilCalled(localSource.saveNotification(first));
    await untilCalled(localSource.saveNotification(second));

    verify(localSource.saveNotification(first)).called(1);
    verify(localSource.saveNotification(second)).called(1);
  });

  test('getNotifications returns local notifications', () async {
    final notifications = [
      TxFailedNotification(date: DateTime.now(), error: '', txHash: ''),
      TxSuccessfulNotification(txHash: '', date: DateTime.now()),
    ];
    when(localSource.getNotifications())
        .thenAnswer((realInvocation) => Future.value(notifications));

    final result = await repository.getNotifications();
    expect(result, equals(notifications));
  });

  test('remoteStream returns local one', () {
    final localStream = BehaviorSubject<NotificationData>();
    when(localSource.liveNotificationsStream).thenAnswer((_) => localStream);

    final remoteNotification =
        TxFailedNotification(date: DateTime.now(), error: '', txHash: '');
    remoteStream.add(remoteNotification);

    final localNotification =
        TxSuccessfulNotification(txHash: '', date: DateTime.now());
    localStream.add(localNotification);

    final stream = repository.liveNotificationsStream;
    expectLater(stream, emitsInOrder([localNotification]));

    localStream.close();
  });
}
