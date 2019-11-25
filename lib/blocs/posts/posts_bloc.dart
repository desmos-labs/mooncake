import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:desmosdemo/blocs/posts/bloc.dart';
import 'package:desmosdemo/models/models.dart';
import 'package:desmosdemo/repositories/repositories.dart';
import 'package:meta/meta.dart';

/// Implementation of [Bloc] that allows to properly deal with
/// events and states related to the list of posts.
class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final PostsRepository repository;

  PostsBloc({@required this.repository});

  @override
  PostsState get initialState => PostsLoading();

  @override
  Stream<PostsState> mapEventToState(PostsEvent event) async* {
    if (event is LoadPosts) {
      yield* _mapLoadPostsEventToState();
    } else if (event is AddPost) {
      yield* _mapAddPostEventToState(event);
    } else if (event is LikePost) {
      yield* _mapLikePostEventToState(event);
    } else if (event is UnlikePost) {
      yield* _mapUnlikePostEventToState(event);
    }
  }

  Stream<PostsState> _mapLoadPostsEventToState() async* {
    try {
      final posts = await repository.loadPosts();
      yield PostsLoaded(posts.where((p) => p.parentId == "0").toList());
    } catch (_) {
      yield PostsNotLoaded();
    }
  }

  Stream<PostsState> _mapAddPostEventToState(AddPost event) async* {
    if (state is PostsLoaded) {
      final List<Post> updatedPosts = List.from((state as PostsLoaded).posts)
        ..add(event.post);
      yield PostsLoaded(updatedPosts);
      repository.savePosts(updatedPosts);
    }
  }

  Stream<PostsState> _mapLikePostEventToState(LikePost event) async* {
    if (state is PostsLoaded) {
      final updatedLikes = await repository.likePost(event.post);
      _updatePostLikes(event.post.id, updatedLikes);
    }
  }

  Stream<PostsState> _mapUnlikePostEventToState(UnlikePost event) async* {
    if (state is PostsLoaded) {
      final updatedLikes = await repository.unlikePost(event.post);
      _updatePostLikes(event.post.id, updatedLikes);
    }
  }

  Stream<PostsState> _updatePostLikes(String postId, List<Like> likes) async* {
    final List<Post> updatedPosts = (state as PostsLoaded)
        .posts
        .map((post) => post.id == postId ? post.copyWith(likes: likes) : post);

    yield PostsLoaded(updatedPosts);
    repository.savePosts(updatedPosts);
  }
}
