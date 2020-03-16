import 'package:equatable/equatable.dart';

/// Represents a generic event that is tied to the carousel containing
/// the list of images associated to a post.
abstract class PostImagesCarouselEvent extends Equatable {
  const PostImagesCarouselEvent();
}

/// Tells the Bloc that the user is now viewing a new image at the given index.
class ImageChanged extends PostImagesCarouselEvent {
  final int newIndex;

  ImageChanged(this.newIndex);

  @override
  List<Object> get props => [newIndex];

  @override
  String toString() => 'ImageChanges { newIndex: $newIndex }';
}
