import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:desmosdemo/blocs/posts/bloc.dart';
import 'package:desmosdemo/repositories/repositories.dart';
import 'package:meta/meta.dart';

import '../blocs.dart';

/// Implementation of [Bloc] that allows to properly deal with
/// events and states related to the list of posts.
class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final PostsRepository repository;
  StreamSubscription _postsSubscription;

  PostsBloc({@required this.repository}) {
    _postsSubscription = repository.postsStream.listen((post) {
      print("Received new post: $post");
      add(LoadPosts());
    });
  }

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
      final posts = await repository.getPosts();
      yield PostsLoaded(posts);
    } catch (e) {
      yield PostsNotLoaded();
    }
  }

  Stream<PostsState> _mapAddPostEventToState(AddPost event) async* {
    if (state is PostsLoaded) {
      await repository.createPost(
        event.message,
        parentId: event.parentId,
      );
      final updatedPosts = await repository.getPosts();
      yield PostsLoaded(updatedPosts);
    }
  }

  Stream<PostsState> _mapLikePostEventToState(LikePost event) async* {
    if (state is PostsLoaded) {
      final updatedPost = await repository.likePost(event.postId);
      final updatedPosts = (state as PostsLoaded)
          .posts
          .map((p) => p.id == updatedPost.id ? updatedPost : p)
          .toList();
      yield PostsLoaded(updatedPosts);
    }
  }

  Stream<PostsState> _mapUnlikePostEventToState(UnlikePost event) async* {
    if (state is PostsLoaded) {
      final updatedPost = await repository.unlikePost(event.postId);
      final updatedPosts = (state as PostsLoaded)
          .posts
          .map((p) => p.id == updatedPost.id ? updatedPost : p)
          .toList();
      yield PostsLoaded(updatedPosts);
    }
  }

  @override
  Future<void> close() {
    _postsSubscription.cancel();
    return super.close();
  }
}
