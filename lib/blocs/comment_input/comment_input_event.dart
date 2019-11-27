import 'package:equatable/equatable.dart';

/// Represents a generic event that is emitted while the user is
/// editing the comment to a post.
abstract class CommentInputEvent extends Equatable {
  const CommentInputEvent();

  @override
  List<Object> get props => [];
}

/// Event that is emitted when the comment text has changed.
class MessageChanged extends CommentInputEvent {
  final String message;

  MessageChanged(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'MessageChanged { message: $message }';
}
