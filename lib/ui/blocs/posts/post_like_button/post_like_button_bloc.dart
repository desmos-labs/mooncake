import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/ui/ui.dart';

import './bloc.dart';

/// Represents the Bloc that handles the interaction with the button that
/// is used to like/unlike a post.
class PostLikeButtonBloc
    extends Bloc<PostLikeButtonEvent, PostLikeButtonState> {
  final PostListItemBloc _postListItemBloc;

  PostLikeButtonBloc({@required PostListItemBloc postListItemBloc})
      : assert(postListItemBloc != null),
        this._postListItemBloc = postListItemBloc;

  factory PostLikeButtonBloc.create(BuildContext context) {
    // ignore: close_sinks
    final itemBloc = BlocProvider.of<PostListItemBloc>(context);
    return PostLikeButtonBloc(
      postListItemBloc: itemBloc,
    )..add(PostLikeDataLoaded(
        isLiked: (itemBloc.state as PostListItemLoaded).isLiked,
        likesCount: (itemBloc.state as PostListItemLoaded).likesCount,
      ));
  }

  @override
  PostLikeButtonState get initialState => PostLikeButtonState.initial();

  @override
  Stream<PostLikeButtonState> mapEventToState(
    PostLikeButtonEvent event,
  ) async* {
    if (event is PostLikeDataLoaded) {
      yield* _mapPostLikeDataLoadedToState(event);
    } else if (event is PostLikeButtonSelectedStateChanged) {
      yield* _mapPostLikeButtonSelectedStateChangedToState(event);
    } else if (event is PostLikeButtonClicked) {
      _mapPostLikeButtonClickedEvent();
    }
  }

  Stream<PostLikeButtonState> _mapPostLikeDataLoadedToState(
    PostLikeDataLoaded event,
  ) async* {
    yield state.copyWith(isLiked: event.isLiked, likesCount: event.likesCount);
  }

  Stream<PostLikeButtonState> _mapPostLikeButtonSelectedStateChangedToState(
    PostLikeButtonSelectedStateChanged event,
  ) async* {
    yield state.copyWith(isSelected: event.selected);
  }

  void _mapPostLikeButtonClickedEvent() {
    _postListItemBloc.add(AddOrRemoveLike());
  }
}
