import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mime_type/mime_type.dart';
import 'package:mooncake/dependency_injection/dependency_injection.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:mooncake/usecases/usecases.dart';

import '../export.dart';

/// Implementation of [Bloc] that allows to deal with [PostInputEvent]
/// and [PostInputState] objects.
class PostInputBloc extends Bloc<PostInputEvent, PostInputState> {
  static const _SHOW_POPUP_KEY = "show_saving_popup";

  final Post _parentPost;

  final NavigatorBloc _navigatorBloc;

  final CreatePostUseCase _createPostUseCase;
  final SavePostUseCase _savePostUseCase;
  final GetSettingUseCase _getSettingUseCase;
  final SaveSettingUseCase _saveSettingUseCase;

  PostInputBloc({
    @required Post parentPost,
    @required NavigatorBloc navigatorBloc,
    @required SavePostUseCase savePostUseCase,
    @required CreatePostUseCase createPostUseCase,
    @required GetSettingUseCase getSettingUseCase,
    @required SaveSettingUseCase saveSettingUseCase,
  })  : _parentPost = parentPost,
        assert(navigatorBloc != null),
        _navigatorBloc = navigatorBloc,
        assert(savePostUseCase != null),
        _savePostUseCase = savePostUseCase,
        assert(createPostUseCase != null),
        _createPostUseCase = createPostUseCase,
        assert(getSettingUseCase != null),
        _getSettingUseCase = getSettingUseCase,
        assert(saveSettingUseCase != null),
        _saveSettingUseCase = saveSettingUseCase;

  factory PostInputBloc.create(BuildContext context, Post parentPost) {
    return PostInputBloc(
      parentPost: parentPost,
      navigatorBloc: BlocProvider.of(context),
      createPostUseCase: Injector.get(),
      savePostUseCase: Injector.get(),
      getSettingUseCase: Injector.get(),
      saveSettingUseCase: Injector.get(),
    );
  }

  @override
  PostInputState get initialState => PostInputState.empty(_parentPost);

  @override
  Stream<PostInputState> mapEventToState(
    PostInputEvent event,
  ) async* {
    if (event is ResetForm) {
      yield PostInputState.empty(_parentPost);
    } else if (event is MessageChanged) {
      yield state.update(message: event.message.trim());
    } else if (event is ToggleAllowsComments) {
      yield state.update(allowsComments: !state.allowsComments);
    } else if (event is ImageAdded) {
      final media = _convert(event.file);
      final images = _removeFileIfPresent(state.medias, media);
      yield state.update(medias: images + [media]);
    } else if (event is ImageRemoved) {
      final images = _removeFileIfPresent(state.medias, event.file);
      yield state.update(medias: images);
    } else if (event is ChangeWillShowPopup) {
      yield* _mapChangeWillShowPopupEventToState();
    } else if (event is SavePost) {
      yield* _mapSavePostEventToState();
    } else if (event is HidePopup) {
      yield state.update(showPopup: false);
    } else if (event is CreatePost) {
      yield* _mapCreatePostEventToState();
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
        .map((m) => File(m.url))
        .where((f) => !_contentsEquals(f, File(media.url)))
        .map((f) => _convert(f))
        .toList();
  }

  Stream<PostInputState> _mapSavePostEventToState() async* {
    final showPopup = await _getSettingUseCase.get(key: _SHOW_POPUP_KEY);
    yield state.update(saving: true, showPopup: showPopup ?? true);

    if (!(showPopup ?? true)) {
      add(CreatePost());
    }
  }

  Stream<PostInputState> _mapCreatePostEventToState() async* {
    yield state.update(saving: true, showPopup: false);

    final post = await _createPostUseCase.create(
      message: state.message,
      allowsComments: state.allowsComments,
      parentId: state.parentPost?.id,
      medias: state.medias,
    );
    await _savePostUseCase.save(post);
    _navigatorBloc.add(GoBack());
  }

  Stream<PostInputState> _mapChangeWillShowPopupEventToState() async* {
    final showAgain = !state.willShowPopupAgain;
    await _saveSettingUseCase.save(key: _SHOW_POPUP_KEY, value: showAgain);
    yield state.update(willShowPopupAgain: showAgain);
  }
}
