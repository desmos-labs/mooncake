import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:mime_type/mime_type.dart';
import 'package:mooncake/entities/entities.dart';

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
      final media = _convert(event.file);
      final images = _removeFileIfPresent(state.medias, media);
      yield state.update(medias: images + [media]);
    } else if (event is ImageRemoved) {
      final images = _removeFileIfPresent(state.medias, event.file);
      yield state.update(medias: images);
    } else if (event is SavePost) {
      yield state.update(saving: true);
    }
  }

  /// Tells whether the [first] and [second] files have the same content
  /// in terms of bytes.
  bool _contentsEquals(File first, File second) {
    return listEquals(first.readAsBytesSync(), second.readAsBytesSync());
  }

  /// Converts the given [file] to a [PostMedia] instance.
  PostMedia _convert(File file) {
    return PostMedia(
      url: file.absolute.path,
      mimeType: mime(file.absolute.path),
    );
  }

  /// Returns a new list of [PostMedia] containing the given [media].
  List<PostMedia> _removeFileIfPresent(
    List<PostMedia> medias,
    PostMedia media,
  ) {
    return medias
        .map((m) => File(media.url))
        .where((f) => !_contentsEquals(f, File(media.url)))
        .map((f) => _convert(f))
        .toList();
  }
}
