import 'dart:io';

import 'package:equatable/equatable.dart';

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

  @override
  String toString() => 'MessageChanged { message: $message }';
}

/// Event that is emitted when the user changes whether or not the post
/// should allow comments.
class AllowsCommentsChanged extends PostInputEvent {
  final bool allowsComments;

  AllowsCommentsChanged(this.allowsComments);

  @override
  List<Object> get props => [allowsComments];

  @override
  String toString() => 'AllowsCommentsChanged { newValue: $allowsComments }';
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
  final File file;

  ImageRemoved(this.file);

  @override
  List<Object> get props => [file];

  @override
  String toString() => 'ImageRemoved { file: $file }';
}

/// Tells the input that the post is being saved
class SavePost extends PostInputEvent {}

/// Tells the input that it needs to be reset
class ResetForm extends PostInputEvent {}
