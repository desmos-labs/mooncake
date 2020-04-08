import 'package:equatable/equatable.dart';

/// Represents a generic event of the notification event.
abstract class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object> get props => [];
}

/// Tells the Bloc that it needs to start loading the notifications.
class LoadNotifications extends NotificationsEvent {
  @override
  String toString() => 'LoadNotifications';
}
