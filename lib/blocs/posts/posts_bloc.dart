import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:desmosdemo/blocs/posts/bloc.dart';
import 'package:desmosdemo/repositories/repositories.dart';
import 'package:meta/meta.dart';

import '../blocs.dart';

/// Implementation of [Bloc] that allows to properly deal with
/// events and states related to the list of posts.
class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final PostsRepository _repository;
  StreamSubscription _postsSubscription;

  PostsBloc({@required PostsRepository repository})
      : assert(repository != null),
        this._repository = repository {
    // Observe for new posts from the chain
    _postsSubscription = repository.postsStream.listen((post) {
      add(LoadPosts());
    });

    // Sync the activities of the user every 15 seconds
    Timer.periodic(Duration(seconds: 15), (t) {
      add(SyncPosts());
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
    } else if (event is SyncPosts) {
      yield* _mapSyncPostsEventToState();
    }
  }

  Stream<PostsState> _mapLoadPostsEventToState() async* {
    try {
      final posts = await _repository.getPosts();
      yield PostsLoaded(posts: posts);
    } catch (e) {
      yield PostsNotLoaded();
    }
  }

  Stream<PostsState> _mapAddPostEventToState(AddPost event) async* {
    if (state is PostsLoaded) {
      await _repository.createPost(
        event.message,
        parentId: event.parentId,
      );
      final updatedPosts = await _repository.getPosts();
      yield (state as PostsLoaded).copyWith(posts: updatedPosts);
    }
  }

  Stream<PostsState> _mapLikePostEventToState(LikePost event) async* {
    if (state is PostsLoaded) {
      final updatedPost = await _repository.likePost(event.postId);
      final updatedPosts = (state as PostsLoaded)
          .posts
          .map((p) => p.id == updatedPost.id ? updatedPost : p)
          .toList();
      yield (state as PostsLoaded).copyWith(posts: updatedPosts);
    }
  }

  Stream<PostsState> _mapUnlikePostEventToState(UnlikePost event) async* {
    if (state is PostsLoaded) {
      final updatedPost = await _repository.unlikePost(event.postId);
      final updatedPosts = (state as PostsLoaded)
          .posts
          .map((p) => p.id == updatedPost.id ? updatedPost : p)
          .toList();
      yield (state as PostsLoaded).copyWith(posts: updatedPosts);
    }
  }

  Stream<PostsState> _mapSyncPostsEventToState() async* {
    if (state is PostsLoaded) {
      yield (state as PostsLoaded).copyWith(showSnackbar: true);
      await _repository.syncActivities();
      yield (state as PostsLoaded).copyWith(showSnackbar: false);
    }
  }

  @override
  Future<void> close() {
    _postsSubscription.cancel();
    return super.close();
  }
}
