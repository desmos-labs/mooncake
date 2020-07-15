import 'dart:io';

import 'package:mooncake/entities/entities.dart';
import './export.dart';

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
