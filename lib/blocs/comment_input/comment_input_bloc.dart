import 'dart:async';

import 'package:bloc/bloc.dart';

import './bloc.dart';

/// Implementation of [Bloc] that allows to deal with [CommentInputEvent]
/// and [CommentInputState] objects.
class CommentInputBloc extends Bloc<CommentInputEvent, CommentInputState> {
  @override
  CommentInputState get initialState => CommentInputState.empty();

  @override
  Stream<CommentInputState> mapEventToState(
    CommentInputEvent event,
  ) async* {
    if (event is MessageChanged) {
      yield* _mapMessageChangedEventToState(event);
    }
  }

  /// Converts a [MessageChanged] event into a [CommentInputState].
  Stream<CommentInputState> _mapMessageChangedEventToState(
    MessageChanged event,
  ) async* {
    if (event.message.isEmpty) {
      yield state.update(isMessageValid: false);
    } else {
      yield state.update(isMessageValid: true);
    }
  }
}
