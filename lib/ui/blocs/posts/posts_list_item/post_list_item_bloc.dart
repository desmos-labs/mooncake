import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/dependency_injection/dependency_injection.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:mooncake/usecases/usecases.dart';

import './bloc.dart';

/// Represents the Bloc that handles the state of a single post item
/// inside the posts list.
class PostListItemBloc extends Bloc<PostListItemEvent, PostListItemState> {
  final MooncakeAccount user;
  final Post post;
  final ManagePostReactionsUseCase _managePostReactionsUseCase;

  PostListItemBloc({
    @required this.user,
    @required this.post,
    @required ManagePostReactionsUseCase managePostReactionsUseCase,
  })  : assert(managePostReactionsUseCase != null),
        this._managePostReactionsUseCase = managePostReactionsUseCase;

  factory PostListItemBloc.create(BuildContext context, Post post) {
    // ignore: close_sinks
    final accountBloc = BlocProvider.of<AccountBloc>(context);
    return PostListItemBloc(
      user: (accountBloc.state as LoggedIn).user,
      post: post,
      managePostReactionsUseCase: Injector.get(),
    );
  }

  @override
  PostListItemState get initialState => PostListItemState(
        user: user,
        post: post,
        actionBarExpanded: false,
      );

  @override
  Stream<PostListItemState> mapEventToState(
    PostListItemEvent event,
  ) async* {
    if (event is AddOrRemoveLike) {
      _convertAddOrRemoveLikeEvent();
    } else if (event is AddOrRemovePostReaction) {
      yield* _mapAddPostReactionEventToState(event);
    } else if (event is ChangeReactionBarExpandedState) {
      yield* _mapChangeReactionBarExpandedStateToState(event);
    }
  }

  /// Converts an [AddOrRemoveLikeEvent] into an
  /// [AddOrRemovePostReaction] event so that it can be handled properly.
  void _convertAddOrRemoveLikeEvent() {
    add(AddOrRemovePostReaction(reaction: Constants.LIKE_REACTION));
  }

  /// Handles the event emitted when the user likes a post
  Stream<PostListItemState> _mapAddPostReactionEventToState(
    AddOrRemovePostReaction event,
  ) async* {
    final updatedPost = await _managePostReactionsUseCase.addOrRemove(
      postId: state.post.id,
      reaction: event.reaction,
    );
    yield state.copyWith(post: updatedPost);
  }

  /// Handles the event emitted when the reaction bar should be expanded
  /// or collapsed.
  Stream<PostListItemState> _mapChangeReactionBarExpandedStateToState(
    ChangeReactionBarExpandedState event,
  ) async* {
    yield state.copyWith(
      actionBarExpanded: !state.actionBarExpanded,
    );
  }
}
