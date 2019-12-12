import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dwitter/dependency_injection/dependency_injection.dart';
import 'package:dwitter/entities/entities.dart';
import 'package:dwitter/usecases/usecases.dart';
import 'package:meta/meta.dart';
import 'package:stream_transform/stream_transform.dart';

import '../export.dart';

/// Implementation of [Bloc] that allows to properly deal with
/// events and states related to the list of posts.
class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final int _syncPeriod;

  final FetchPostsUseCase _fetchPostsUseCase;
  final CreatePostUseCase _createPostUseCase;
  final LikePostUseCase _likePostUseCase;
  final UnlikePostUseCase _unlikePostUseCase;
  final GetPostsUseCase _getPostsUseCase;
  final SyncPostsUseCase _syncPostsUseCase;

  Timer _syncTimer;
  StreamSubscription _postsSubscription;

  PostsBloc({
    @required int syncPeriod,
    @required FetchPostsUseCase fetchPostsUseCase,
    @required CreatePostUseCase createPostUseCase,
    @required LikePostUseCase likePostUseCase,
    @required UnlikePostUseCase unlikePostUseCase,
    @required GetPostsUseCase getPostsUseCase,
    @required SyncPostsUseCase syncPostsUseCase,
  })  : _syncPeriod = syncPeriod,
        assert(fetchPostsUseCase != null),
        _fetchPostsUseCase = fetchPostsUseCase,
        assert(createPostUseCase != null),
        _createPostUseCase = createPostUseCase,
        assert(likePostUseCase != null),
        _likePostUseCase = likePostUseCase,
        assert(unlikePostUseCase != null),
        _unlikePostUseCase = unlikePostUseCase,
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
  Stream<PostsState> transformEvents(
    Stream<PostsEvent> events,
    Stream<PostsState> Function(PostsEvent event) next,
  ) {
    return super.transformEvents(
      events.debounce(Duration(milliseconds: 500)),
      next,
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
      yield* _mapSyncPostsCompletedEventToState();
    }
  }

  /// Handles the event that is emitted when there's the need to fetch
  /// all the stored posts on the chain since the last sync
  Stream<PostsState> _mapFetchPostsEventToState() async* {
    // Subscribe to the stream of posts
    _postsSubscription = _getPostsUseCase.stream().listen((post) {
      // When we get new posts, simply reload the
      // currently shown list of posts
      add(LoadPosts(nextPage: false));
    });

    // Show the fetching snackbar
    final currentState = state;
    if (currentState is PostsLoaded) {
      yield currentState.copyWith(fetchingPosts: true);
    }

    // Wait for new posts
    _fetchPostsUseCase.fetch().then((_) {
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
  Future<List<Post>> _getPosts({int page = 0}) async {
    final posts = await _getPostsUseCase.get(page: page);
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
      // We have already loaded some posts, we need to define in which
      // case we are right now

      if (event.nextPage) {
        // Show the loading bar
        yield currentState.copyWith(isLoadingNewPage: true);

        // We're at the end of a page, just load the next one
        final posts = await _getPosts(page: currentState.page + 1);
        yield currentState.copyWith(
          page: currentState.page + 1,
          posts: currentState.posts + posts,
          hasReachedMax: posts.isEmpty,
          isLoadingNewPage: false,
        );
      } else {
        // We're not at the end, but someone else has triggered to load the
        // posts again
        final newPosts = await _getPosts(page: currentState.page);
        final posts = currentState.posts.map((post) {
          // Find a post with the same id but new data
          final newPostWithSameId = newPosts.firstWhere(
            (p) => p.id == post.id,
            orElse: () => null,
          );

          // If the posts exists, return that one. Otherwise
          // return the old one
          if (newPostWithSameId != null) {
            return newPostWithSameId;
          } else {
            return post;
          }
        }).toList();

        yield currentState.copyWith(posts: posts);
      }
    } else {
      // We never loaded any post before, so load the first page
      final posts = await _getPosts(page: 0);
      yield PostsLoaded(page: 0, posts: posts);
    }
  }

  /// Handles the event that is emitted when the user creates a new post
  Stream<PostsState> _mapAddPostEventToState(AddPost event) async* {
    if (state is PostsLoaded) {
      // When a post is added, simply save it and refresh the list
      // of currently shown posts
      await _createPostUseCase.create(event.message, parentId: event.parentId);
      add(LoadPosts(nextPage: false));
    }
  }

  /// Handles the event emitted when the user likes a post
  Stream<PostsState> _mapLikePostEventToState(LikePost event) async* {
    if (state is PostsLoaded) {
      final updatedPost = await _likePostUseCase.like(event.postId);
      final updatedPosts = (state as PostsLoaded)
          .posts
          .map((p) => p.id == updatedPost.id ? updatedPost : p)
          .toList();
      yield (state as PostsLoaded).copyWith(posts: updatedPosts);
    }
  }

  /// Handles the event telling that the user has unliked a previously
  /// liked post
  Stream<PostsState> _mapUnlikePostEventToState(UnlikePost event) async* {
    if (state is PostsLoaded) {
      final updatedPost = await _unlikePostUseCase.unlike(event.postId);
      final updatedPosts = (state as PostsLoaded)
          .posts
          .map((p) => p.id == updatedPost.id ? updatedPost : p)
          .toList();
      yield (state as PostsLoaded).copyWith(posts: updatedPosts);
    }
  }

  /// Handles the event emitted when the posts must be synced uploading
  /// all the changes stored locally to the chain
  Stream<PostsState> _mapSyncPostsEventToState() async* {
    final currentState = state;
    if (currentState is PostsLoaded) {
      // Show the snackbar
      yield currentState.copyWith(syncingPosts: true);

      // Wait for the sync
      _syncPostsUseCase.sync().then((_) {
        add(SyncPostsCompleted());
      });
    }
  }

  /// Handles the event that tells the bloc the synchronization has completed
  Stream<PostsState> _mapSyncPostsCompletedEventToState() async* {
    // Once the sync has been completed, hide the bar and load the posts again
    final currentState = state;
    if (currentState is PostsLoaded) {
      yield currentState.copyWith(syncingPosts: false);
      add(LoadPosts(nextPage: false));
    }
  }

  @override
  Future<void> close() {
    _postsSubscription?.cancel();
    _syncTimer?.cancel();
    return super.close();
  }
}
