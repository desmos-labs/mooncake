import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Represents the state of the carousel containing the list of images.
class PostImagesCarouselState extends Equatable {
  final int currentIndex;

  const PostImagesCarouselState({@required this.currentIndex});

  factory PostImagesCarouselState.initial() {
    return PostImagesCarouselState(
      currentIndex: 0,
    );
  }

  PostImagesCarouselState copyWith({
    int currentIndex,
  }) {
    return PostImagesCarouselState(
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }

  @override
  List<Object> get props => [currentIndex];

  @override
  String toString() => 'PostImagesCarouselState {'
      'currentIndex: $currentIndex '
      '}';
}
