import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:desmosdemo/blocs/posts/bloc.dart';
import 'package:desmosdemo/models/models.dart';
import 'package:desmosdemo/repositories/repositories.dart';
import 'package:meta/meta.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final PostsRepository postsRepository;

  PostsBloc({@required this.postsRepository});

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
      final posts = await postsRepository.loadPosts();
      yield PostsLoaded(posts);
    } catch (_) {
      yield PostsNotLoaded();
    }
  }

  Stream<PostsState> _mapAddPostEventToState(AddPost event) async* {
    if (state is PostsLoaded) {
      final List<Post> updatedPosts = List.from((state as PostsLoaded).posts)
        ..add(event.post);
      yield PostsLoaded(updatedPosts);
      postsRepository.savePosts(updatedPosts);
    }
  }

  Stream<PostsState> _mapLikePostEventToState(LikePost event) async* {
    if (state is PostsLoaded) {
      final updatedLikes = await postsRepository.likePost(event.post);
      _updatePostLikes(event.post.id, updatedLikes);
    }
  }

  Stream<PostsState> _mapUnlikePostEventToState(UnlikePost event) async* {
    if (state is PostsLoaded) {
      final updatedLikes = await postsRepository.unlikePost(event.post);
      _updatePostLikes(event.post.id, updatedLikes);
    }
  }

  Stream<PostsState> _updatePostLikes(String postId, List<Like> likes) async* {
    final List<Post> updatedPosts = (state as PostsLoaded)
        .posts
        .map((post) => post.id == postId ? post.copyWith(likes: likes) : post);

    yield PostsLoaded(updatedPosts);
    postsRepository.savePosts(updatedPosts);
  }
}
