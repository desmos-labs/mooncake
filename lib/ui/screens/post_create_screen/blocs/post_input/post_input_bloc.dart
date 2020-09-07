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

import 'export.dart';

/// Implementation of [Bloc] that allows to deal with [PostInputEvent]
/// and [PostInputState] objects.
class PostInputBloc extends Bloc<PostInputEvent, PostInputState> {
  static const _SHOW_POPUP_KEY = 'show_saving_popup';

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
        _saveSettingUseCase = saveSettingUseCase,
        super(PostInputState.empty(parentPost));

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
  Stream<PostInputState> mapEventToState(
    PostInputEvent event,
  ) async* {
    if (event is ResetForm) {
      yield PostInputState.empty(_parentPost);
    } else if (event is MessageChanged) {
      yield state.copyWith(message: event.message.trim());
    } else if (event is ToggleAllowsComments) {
      yield state.copyWith(allowsComments: !state.allowsComments);
    } else if (event is ImageAdded) {
      yield* _mapImageAddedToState(event);
    } else if (event is ImageRemoved) {
      yield* _mapImageRemovedToState(event);
    } else if (event is PostInputPollEvent) {
      yield* _mapPollEventsToState(event);
    } else if (event is ChangeWillShowPopup) {
      yield* _mapChangeWillShowPopupEventToState();
    } else if (event is SavePost) {
      yield* _mapSavePostEventToState();
    } else if (event is HidePopup) {
      yield state.copyWith(showPopup: false);
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
      uri: file.absolute.path,
      mimeType: mime(file.absolute.path),
    );
  }

  /// Returns a new list of [PostMedia] containing the given [media].
  List<PostMedia> _removeFileIfPresent(
    List<PostMedia> medias,
    PostMedia media,
  ) {
    return medias
        .map((m) => File(m.uri))
        .where((f) => !_contentsEquals(f, File(media.uri)))
        .map((f) => _convert(f))
        .toList();
  }

  // ------ Images ------

  Stream<PostInputState> _mapImageAddedToState(ImageAdded event) async* {
    final media = _convert(event.file);
    final images = _removeFileIfPresent(state.medias, media);

    yield state.copyWith(medias: images + [media]);
  }

  Stream<PostInputState> _mapImageRemovedToState(ImageRemoved event) async* {
    final images = _removeFileIfPresent(state.medias, event.file);
    yield state.copyWith(medias: images);
  }

  // ------ Polls ------

  Stream<PostInputState> _mapPollEventsToState(
    PostInputPollEvent event,
  ) async* {
    if (event is CreatePoll) {
      yield state.copyWith(poll: state.poll ?? PostPoll.empty());
    } else if (event is TogglePollDisplay) {
      if (state.poll == null) {
        yield state.copyWith(poll: PostPoll.empty());
      } else {
        yield state.removePoll();
      }
    } else if (event is UpdatePollOption) {
      // Update the option
      final options = state.poll.options.map((option) {
        return option.id == event.index
            ? option.copyWith(text: event.option)
            : option;
      }).toList();

      // Update the state
      final poll = state.poll.copyWith(options: options);
      yield state.copyWith(poll: poll);
    } else if (event is AddPollOption) {
      // Add the option
      final options = state.poll.options +
          [PollOption(id: state.poll.options.length, text: '')];

      // Update the state
      final poll = state.poll.copyWith(options: options);
      yield state.copyWith(poll: poll);
    } else if (event is DeletePollOption) {
      // Delete the option
      var options = <PollOption>[...state.poll.options];
      options = options.where((option) => option.id != event.index).toList();

      // Update the options indexes
      for (var i = 0; i < options.length; i++) {
        options[i] = options[i].copyWith(index: i);
      }

      // Update the state
      final poll = state.poll.copyWith(options: options);
      yield state.copyWith(poll: poll);
    } else if (event is ChangePollDate) {
      final poll = state.poll.copyWith(endDate: event.endDate);
      yield state.copyWith(poll: poll);
    }
  }

  Stream<PostInputState> _mapSavePostEventToState() async* {
    final showPopup =
        await _getSettingUseCase.get(key: _SHOW_POPUP_KEY) as bool;

    yield state.copyWith(saving: true, showPopup: showPopup ?? true);

    if (!(showPopup ?? true)) {
      yield* _mapCreatePostEventToState();
    }
  }

  Stream<PostInputState> _mapCreatePostEventToState() async* {
    yield state.copyWith(saving: true, showPopup: false);

    final post = await _createPostUseCase.create(
      // If the post has a poll, the entered message should
      // be the poll question instead
      message: state.hasPoll ? null : state.message,
      allowsComments: state.allowsComments,
      parentId: state.parentPost?.id,
      medias: state.medias,
      // If the post has a poll, copy the message as the question
      poll: state.hasPoll ? state.poll.copyWith(question: state.message) : null,
    );
    await _savePostUseCase.save(post);
    _navigatorBloc.add(GoBack());
  }

  Stream<PostInputState> _mapChangeWillShowPopupEventToState() async* {
    final showAgain = !state.willShowPopupAgain;
    await _saveSettingUseCase.save(key: _SHOW_POPUP_KEY, value: showAgain);
    yield state.copyWith(willShowPopupAgain: showAgain);
  }
}
