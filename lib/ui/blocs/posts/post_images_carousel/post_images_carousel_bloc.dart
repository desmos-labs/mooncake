import 'dart:async';
import 'package:bloc/bloc.dart';
import './bloc.dart';

/// Represents the Bloc that handles the event and state of the images
/// carousel of each post item.
class PostImagesCarouselBloc
    extends Bloc<PostImagesCarouselEvent, PostImagesCarouselState> {
  PostImagesCarouselBloc();

  factory PostImagesCarouselBloc.create() {
    return PostImagesCarouselBloc();
  }

  @override
  PostImagesCarouselState get initialState => PostImagesCarouselState.initial();

  @override
  Stream<PostImagesCarouselState> mapEventToState(
    PostImagesCarouselEvent event,
  ) async* {
    if (event is ImageChanged) {
      yield state.copyWith(currentIndex: event.newIndex);
    }
  }
}
