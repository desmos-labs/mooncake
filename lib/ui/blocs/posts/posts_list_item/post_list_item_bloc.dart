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

/// Represents the BLoC that handles the state of a single post item
/// inside the posts list.
class PostListItemBloc extends Bloc<PostListItemEvent, PostListItemState> {
  final ManagePostReactionsUseCase _managePostReactionsUseCase;

  PostListItemBloc({
    @required ManagePostReactionsUseCase managePostReactionsUseCase,
  })  : assert(managePostReactionsUseCase != null),
        this._managePostReactionsUseCase = managePostReactionsUseCase;

  factory PostListItemBloc.create(BuildContext context, Post post) {
    // ignore: close_sinks
    final accountBloc = BlocProvider.of<AccountBloc>(context);
    return PostListItemBloc(
      managePostReactionsUseCase: Injector.get(),
    )..add(DataLoaded(
        user: (accountBloc.state as LoggedIn).user,
        post: post,
      ));
  }

  @override
  PostListItemState get initialState => PostListItemLoading();

  @override
  Stream<PostListItemLoaded> mapEventToState(
    PostListItemEvent event,
  ) async* {
    if (event is DataLoaded) {
      yield* _mapDataLoadedEventToState(event);
    } else if (event is AddOrRemoveLike) {
      _convertAddOrRemoveLikeEvent();
    } else if (event is AddOrRemovePostReaction) {
      yield* _mapAddPostReactionEventToState(event);
    } else if (event is ChangeReactionBarExpandedState) {
      yield* _mapChangeReactionBarExpandedStateToState(event);
    }
  }

  /// Handles the event telling that the data has been loaded.
  Stream<PostListItemLoaded> _mapDataLoadedEventToState(
    DataLoaded event,
  ) async* {
    yield PostListItemLoaded(
      actionBarExpanded: false,
      post: event.post,
      user: event.user,
    );
  }

  /// Converts an [AddOrRemoveLikeEvent] into an
  /// [AddOrRemovePostReaction] event so that it can be handled properly.
  void _convertAddOrRemoveLikeEvent() {
    add(AddOrRemovePostReaction(reaction: Constants.LIKE_REACTION));
  }

  /// Handles the event emitted when the user likes a post
  Stream<PostListItemLoaded> _mapAddPostReactionEventToState(
    AddOrRemovePostReaction event,
  ) async* {
    final currentState = state;
    if (currentState is PostListItemLoaded) {
      final updatedPost = await _managePostReactionsUseCase.addOrRemove(
        postId: currentState.post.id,
        reaction: event.reaction,
      );
      yield currentState.copyWith(post: updatedPost);
    }
  }

  /// Handles the event emitted when the reaction bar should be expanded
  /// or collapsed.
  Stream<PostListItemLoaded> _mapChangeReactionBarExpandedStateToState(
    ChangeReactionBarExpandedState event,
  ) async* {
    final currentState = state;
    if (currentState is PostListItemLoaded) {
      yield currentState.copyWith(
        actionBarExpanded: !currentState.actionBarExpanded,
      );
    }
  }
}
