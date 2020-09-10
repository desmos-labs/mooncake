import 'package:equatable/equatable.dart';
import 'package:mooncake/entities/entities.dart';

/// Represents the generic that of the notifications list.
abstract class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object> get props => [];
}

/// Represents the loading state of the notifications.
class LoadingNotifications extends NotificationsState {
  @override
  String toString() => 'LoadingNotifications';
}

/// Represents the state of the screen once the notifications has been loaded.
class NotificationsLoaded extends NotificationsState {
  final List<BasePostInteractionNotification> notifications;

  NotificationsLoaded(this.notifications);

  factory NotificationsLoaded.initial() {
    return NotificationsLoaded([]);
  }

  @override
  List<Object> get props => [notifications];

  @override
  String toString() => 'NotificationsLoaded { notifications: $notifications }';
}
