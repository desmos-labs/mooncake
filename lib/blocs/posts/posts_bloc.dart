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
      final posts = await repository.getPosts();
      yield PostsLoaded(posts.where((p) => p.parentId == "0").toList());
    } catch (e) {
      print(e);
      yield PostsNotLoaded();
    }
  }

  Stream<PostsState> _mapAddPostEventToState(AddPost event) async* {
    if (state is PostsLoaded) {
      final newPost = await repository.createPost(event.message);
      await repository.savePost(newPost);
      final updatedPosts = [newPost] + (state as PostsLoaded).posts;
      yield PostsLoaded(updatedPosts);
    }
  }

  Stream<PostsState> _mapLikePostEventToState(LikePost event) async* {
    if (state is PostsLoaded) {
      final updatedPost = await repository.likePost(event.post);
      final updatedPosts = (state as PostsLoaded)
          .posts
          .map((p) => p.id == updatedPost.id ? updatedPost : p)
          .toList();
      yield PostsLoaded(updatedPosts);
      await repository.savePost(updatedPost);
    }
  }

  Stream<PostsState> _mapUnlikePostEventToState(UnlikePost event) async* {
    if (state is PostsLoaded) {
      final updatedPost = await repository.unlikePost(event.post);
      final updatedPosts = (state as PostsLoaded)
          .posts
          .map((p) => p.id == updatedPost.id ? updatedPost : p)
          .toList();
      yield PostsLoaded(updatedPosts);
      await repository.savePost(updatedPost);
    }
  }
}
