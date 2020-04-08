import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:mooncake/entities/entities.dart';

/// Represents a generic event that is emitted while the user is
/// editing the comment to a post.
abstract class PostInputEvent extends Equatable {
  const PostInputEvent();

  @override
  List<Object> get props => [];
}

/// Event that is emitted when the comment text has changed.
class MessageChanged extends PostInputEvent {
  final String message;

  MessageChanged(this.message);

  @override
  List<Object> get props => [message];
}

/// Event that tells that the user has toggled the allowing of comments.
class ToggleAllowsComments extends PostInputEvent {
  @override
  String toString() => 'ToggleAllowsComments';
}

/// Event that is emitted upon the user adds an image to the post.
class ImageAdded extends PostInputEvent {
  final File file;

  ImageAdded(this.file);

  @override
  List<Object> get props => [file];

  @override
  String toString() => 'ImageAdded { file: $file }';
}

/// Event that is emitted when the user wants to remove an image from a post.
class ImageRemoved extends PostInputEvent {
  final PostMedia file;

  ImageRemoved(this.file);

  @override
  List<Object> get props => [file];

  @override
  String toString() => 'ImageRemoved { file: $file }';
}

/// Tells the input that the post is being saved
class SavePost extends PostInputEvent {}

/// Tells that the user wants to show (or not) the alert popup again in the
/// future.
class ChangeWillShowPopup extends PostInputEvent {}

/// Tells the Bloc that the popup has been hidden from the user.
class HidePopup extends PostInputEvent {}

/// Tells the Bloc that the user has accepted everything and wants to crete
/// the post.
class CreatePost extends PostInputEvent {}

/// Tells the input that it needs to be reset
class ResetForm extends PostInputEvent {}
