import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:mooncake/dependency_injection/dependency_injection.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/usecases/usecases.dart';
import 'package:meta/meta.dart';

import '../export.dart';

/// Implementation of [Bloc] that allows to properly deal with
/// events and states related to the list of posts.
class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final int _syncPeriod;

  final FetchPostsUseCase _fetchPostsUseCase;
  final CreatePostUseCase _createPostUseCase;
  final AddReactionToPostUseCase _addReactionToPostUseCase;
  final RemoveReactionFromPostUseCase _removeReactionFromPostUseCase;
  final GetPostsUseCase _getPostsUseCase;
  final SyncPostsUseCase _syncPostsUseCase;

  Timer _syncTimer;
  StreamSubscription _postsSubscription;

  PostsBloc({
    @required int syncPeriod,
    @required FetchPostsUseCase fetchPostsUseCase,
    @required CreatePostUseCase createPostUseCase,
    @required AddReactionToPostUseCase likePostUseCase,
    @required RemoveReactionFromPostUseCase unlikePostUseCase,
    @required GetPostsUseCase getPostsUseCase,
    @required SyncPostsUseCase syncPostsUseCase,
  })  : _syncPeriod = syncPeriod,
        assert(fetchPostsUseCase != null),
        _fetchPostsUseCase = fetchPostsUseCase,
        assert(createPostUseCase != null),
        _createPostUseCase = createPostUseCase,
        assert(likePostUseCase != null),
        _addReactionToPostUseCase = likePostUseCase,
        assert(unlikePostUseCase != null),
        _removeReactionFromPostUseCase = unlikePostUseCase,
        assert(getPostsUseCase != null),
        _getPostsUseCase = getPostsUseCase,
        assert(syncPostsUseCase != null),
        _syncPostsUseCase = syncPostsUseCase;

  factory PostsBloc.create({int syncPeriod = 20}) {
    return PostsBloc(
      syncPeriod: syncPeriod,
      fetchPostsUseCase: Injector.get(),
      createPostUseCase: Injector.get(),
      likePostUseCase: Injector.get(),
      unlikePostUseCase: Injector.get(),
      getPostsUseCase: Injector.get(),
      syncPostsUseCase: Injector.get(),
    );
  }

  @override
  PostsState get initialState => PostsLoading();

  @override
  Stream<PostsState> mapEventToState(PostsEvent event) async* {
    if (event is FetchPosts) {
      yield* _mapFetchPostsEventToState();
    } else if (event is FetchPostsCompleted) {
      yield* _mapFetchPostsCompletedEventToState();
    } else if (event is LoadPosts) {
      yield* _mapLoadPostsEventToState(event);
    } else if (event is AddPost) {
      yield* _mapAddPostEventToState(event);
    } else if (event is LikePost) {
      yield* _mapLikePostEventToState(event);
    } else if (event is UnlikePost) {
      yield* _mapUnlikePostEventToState(event);
    } else if (event is SyncPosts) {
      yield* _mapSyncPostsEventToState();
    } else if (event is SyncPostsCompleted) {
      yield* _mapSyncPostsCompletedEventToState(event);
    }
  }

  /// Handles the event that is emitted when there's the need to fetch
  /// all the stored posts on the chain since the last sync
  Stream<PostsState> _mapFetchPostsEventToState() async* {
    // Subscribe to the stream of posts
    _postsSubscription = _getPostsUseCase.stream().listen((post) {
      // When we get new posts, simply reload the
      // currently shown list of posts
      add(LoadPosts());
    });

    // Show the fetching snackbar
    final currentState = state;
    if (currentState is PostsLoaded) {
      yield currentState.copyWith(fetchingPosts: true);
    }

    // Wait for new posts
    _fetchPostsUseCase.fetch().catchError((error) {
      print('Error while fecthing posts: $error');
    }).then((_) {
      add(FetchPostsCompleted());
    });
  }

  /// Handles the event that is emitted when the posts are completely
  /// synced and all the previously stored posts have been downloaded
  /// from the chain
  Stream<PostsState> _mapFetchPostsCompletedEventToState() async* {
    // Once the fetch has completed simply hide the snackbar
    final currentState = state;
    if (currentState is PostsLoaded) {
      yield currentState.copyWith(fetchingPosts: false);
    }
  }

  /// Allows to fetch the given [page] of posts objects
  Future<List<Post>> _getPosts() async {
    final posts = await _getPostsUseCase.get();
    posts.sort((p1, p2) => p2.compareTo(p1));
    return posts;
  }

  /// Handles the event emitted when the posts list should be refreshed
  Stream<PostsState> _mapLoadPostsEventToState(LoadPosts event) async* {
    // Start fetching new post
    if (_postsSubscription == null) {
      add(FetchPosts());
    }

    // Sync the activities of the user every _syncPeriod seconds
    if (_syncTimer?.isActive != true) {
      _syncTimer?.cancel();
      _syncTimer = Timer.periodic(Duration(seconds: _syncPeriod), (t) {
        add(SyncPosts());
      });
    }

    final currentState = state;
    if (currentState is PostsLoaded) {
      // We have already loaded some posts
      final newPosts = await _getPosts();
      yield currentState.copyWith(posts: newPosts);
    } else {
      // We never loaded any post before
      final posts = await _getPosts();
      yield PostsLoaded(posts: posts);
    }
  }

  /// Handles the event that is emitted when the user creates a new post
  Stream<PostsState> _mapAddPostEventToState(AddPost event) async* {
    if (state is PostsLoaded) {
      // When a post is added, simply save it and refresh the list
      // of currently shown posts
      await _createPostUseCase.create(event.message, parentId: event.parentId);
      add(LoadPosts());
    }
  }

  /// Handles the event emitted when the user likes a post
  Stream<PostsState> _mapLikePostEventToState(LikePost event) async* {
    if (state is PostsLoaded) {
//      final updatedPost = await _addReactionToPostUseCase.react(event.postId);
//      final updatedPosts = (state as PostsLoaded)
//          .posts
//          .map((p) => p.id == updatedPost.id ? updatedPost : p)
//          .toList();
//      yield (state as PostsLoaded).copyWith(posts: updatedPosts);
    }
  }

  /// Handles the event telling that the user has unliked a previously
  /// liked post
  Stream<PostsState> _mapUnlikePostEventToState(UnlikePost event) async* {
//    if (state is PostsLoaded) {
//      final updatedPost = await _removeReactionFromPostUseCase.remove(event.postId);
//      final updatedPosts = (state as PostsLoaded)
//          .posts
//          .map((p) => p.id == updatedPost.id ? updatedPost : p)
//          .toList();
//      yield (state as PostsLoaded).copyWith(posts: updatedPosts);
//    }
  }

  /// Handles the event emitted when the posts must be synced uploading
  /// all the changes stored locally to the chain
  Stream<PostsState> _mapSyncPostsEventToState() async* {
    final currentState = state;
    if (currentState is PostsLoaded) {
      // Show the snackbar
      yield currentState.copyWith(syncingPosts: true);

      // Wait for the sync
      _syncPostsUseCase.sync().catchError((error) {
        print("Sync error: $error");
        add(SyncPostsCompleted());
      }).then((syncedPosts) {
        add(SyncPostsCompleted());
      });
    }
  }

  /// Handles the event that tells the bloc the synchronization has completed
  Stream<PostsState> _mapSyncPostsCompletedEventToState(
    SyncPostsCompleted event,
  ) async* {
    // Once the sync has been completed, hide the bar and load the new posts
    final currentState = state;
    if (currentState is PostsLoaded) {
      yield currentState.copyWith(syncingPosts: false);
      add(LoadPosts());
    }
  }

  @override
  Future<void> close() {
    _postsSubscription?.cancel();
    _syncTimer?.cancel();
    return super.close();
  }
}
