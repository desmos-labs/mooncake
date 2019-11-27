import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:desmosdemo/repositories/posts_repository.dart';
import 'package:meta/meta.dart';

import './bloc.dart';

/// [Bloc] instance that allows to properly deal with post comments.
class PostCommentsBloc extends Bloc<PostCommentsEvent, PostCommentsState> {
  final PostsRepository repository;

  PostCommentsBloc({@required this.repository});

  @override
  PostCommentsState get initialState => PostCommentsLoading();

  @override
  Stream<PostCommentsState> mapEventToState(PostCommentsEvent event) async* {
    if (event is LoadPostComments) {
      yield* _mapLoadPostCommentsEventToState(event);
    } else if (event is CreatePostComment) {
      yield* _mapCreatePostCommentEventToState(event);
    }
  }

  /// Maps a single [LoadPostComments] event to a series of [PostCommentState]s.
  Stream<PostCommentsState> _mapLoadPostCommentsEventToState(
    LoadPostComments event,
  ) async* {
    final comments = await repository.getCommentsForPost(event.postId);
    yield PostCommentsLoaded(comments);
  }

  Stream<PostCommentsState> _mapCreatePostCommentEventToState(
    CreatePostComment event,
  ) async* {
    if (state is PostCommentsLoaded) {
      // Create the comment with the proper parent id and save it
      final comment = await repository.createPost(
        event.message,
        parentId: event.postId,
      );
      await repository.savePost(comment);

      // Update the comments
      final comments = (state as PostCommentsLoaded).comments;
      yield PostCommentsLoaded([comment] + comments);
    }
  }
}
