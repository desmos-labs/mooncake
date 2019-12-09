import 'dart:async';

import 'package:bloc/bloc.dart';

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
    }
  }
}
