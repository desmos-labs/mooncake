import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/usecases/usecases.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:mooncake/entities/entities.dart';

class MockGetNotificationsUseCase extends Mock
    implements GetNotificationsUseCase {}

void main() {
  MockGetNotificationsUseCase mockGetNotificationsUseCase;

  setUp(() {
    mockGetNotificationsUseCase = MockGetNotificationsUseCase();
  });

  group(
    'NotificationsBloc',
    () {
      NotificationsBloc notificationsBloc;
      setUp(
        () {
          notificationsBloc = NotificationsBloc(
              getNotificationsUseCase: mockGetNotificationsUseCase);
        },
      );

      blocTest(
        'LoadNotifications: work properly',
        build: () {
          when(mockGetNotificationsUseCase.single())
              .thenAnswer((_) => Future.value([
                    TxSuccessfulNotification(
                        date: DateTime.now(), txHash: 'hash-1'),
                    TxFailedNotification(
                        date: DateTime.now(), txHash: 'hash-2', error: 'e'),
                  ]));
          return notificationsBloc;
        },
        act: (bloc) async {
          bloc.add(LoadNotifications());
        },
        expect: [
          LoadingNotifications(),
          NotificationsLoaded([]),
        ],
      );
    },
  );
}
