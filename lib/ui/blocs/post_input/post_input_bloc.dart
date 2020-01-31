import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

import '../export.dart';

/// Implementation of [Bloc] that allows to deal with [PostInputEvent]
/// and [PostInputState] objects.
class PostInputBloc extends Bloc<PostInputEvent, PostInputState> {
  PostInputBloc();

  factory PostInputBloc.create() {
    return PostInputBloc();
  }

  @override
  PostInputState get initialState => PostInputState.empty();

  @override
  Stream<PostInputState> mapEventToState(
    PostInputEvent event,
  ) async* {
    if (event is ResetForm) {
      yield PostInputState.empty();
    } else if (event is MessageChanged) {
      yield state.update(message: event.message);
    } else if (event is AllowsCommentsChanged) {
      yield state.update(allowsComments: event.allowsComments);
    } else if (event is ImageAdded) {
      final images = _removeFileIfPresent(state.images, event.file);
      yield state.update(images: images + [event.file]);
    } else if (event is ImageRemoved) {
      final images = _removeFileIfPresent(state.images, event.file);
      yield state.update(images: images);
    } else if (event is SavePost) {
      yield state.update(saving: true);
    }
  }

  List<File> _removeFileIfPresent(List<File> files, File file) {
    return files
        .where((f) => !listEquals(f.readAsBytesSync(), file.readAsBytesSync()))
        .toList();
  }
}
