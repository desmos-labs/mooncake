import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/dependency_injection/injector.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/usecases/usecases.dart';

import 'export.dart';

/// Represents the Bloc that is used to shows the list of notifications
/// the user has received.
class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final GetNotificationsUseCase _getNotificationsUseCase;

  NotificationsBloc({
    @required GetNotificationsUseCase getNotificationsUseCase,
  })  : assert(getNotificationsUseCase != null),
        _getNotificationsUseCase = getNotificationsUseCase,
        super(NotificationsLoaded.initial());

  factory NotificationsBloc.create() {
    return NotificationsBloc(
      getNotificationsUseCase: Injector.get(),
    );
  }

  @override
  Stream<NotificationsState> mapEventToState(NotificationsEvent event) async* {
    if (event is LoadNotifications) {
      yield* _mapLoadNotificationsEventToState(event);
    }
  }

  /// Maps a [LoadNotificationEvent] to a list of states.
  Stream<NotificationsState> _mapLoadNotificationsEventToState(
    LoadNotifications event,
  ) async* {
    yield LoadingNotifications();

    // Load the notifications
    final notifications = await _getNotificationsUseCase.single();
    final notificationsToShow =
        notifications.whereType<BasePostInteractionNotification>().toList();

    yield NotificationsLoaded(notificationsToShow);
  }
}
