import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/dependency_injection/dependency_injection.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/usecases/usecases.dart';

import '../export.dart';

/// Implementation of [Bloc] that allows to properly deal with
/// events and states related to the list of posts.
class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final int _syncPeriod;

  final GetAddressUseCase _getAddressUseCase;
  final AddPostReactionUseCase _addReactionToPostUseCase;
  final RemoveReactionFromPostUseCase _removeReactionFromPostUseCase;
  final GetPostsUseCase _getPostsUseCase;
  final SyncPostsUseCase _syncPostsUseCase;
  final FirebaseAnalytics _analytics;

  Timer _syncTimer;
  StreamSubscription _postsSubscription;

  PostsBloc({
    @required int syncPeriod,
    @required AddPostReactionUseCase likePostUseCase,
    @required RemoveReactionFromPostUseCase unlikePostUseCase,
    @required GetPostsUseCase getPostsUseCase,
    @required SyncPostsUseCase syncPostsUseCase,
    @required GetAddressUseCase getAddressUseCase,
    @required FirebaseAnalytics analytics,
  })  : _syncPeriod = syncPeriod,
        assert(likePostUseCase != null),
        _addReactionToPostUseCase = likePostUseCase,
        assert(unlikePostUseCase != null),
        _removeReactionFromPostUseCase = unlikePostUseCase,
        assert(getPostsUseCase != null),
        _getPostsUseCase = getPostsUseCase,
        assert(syncPostsUseCase != null),
        _syncPostsUseCase = syncPostsUseCase,
        assert(getAddressUseCase != null),
        _getAddressUseCase = getAddressUseCase,
        assert(analytics != null),
        _analytics = analytics;

  factory PostsBloc.create({int syncPeriod = 30}) {
    return PostsBloc(
      syncPeriod: syncPeriod,
      likePostUseCase: Injector.get(),
      unlikePostUseCase: Injector.get(),
      getPostsUseCase: Injector.get(),
      syncPostsUseCase: Injector.get(),
      getAddressUseCase: Injector.get(),
      analytics: Injector.get(),
    );
  }

  @override
  PostsState get initialState => PostsLoading();

  @override
  Stream<PostsState> mapEventToState(PostsEvent event) async* {
    if (event is LoadPosts) {
      yield* _mapLoadPostsEventToState(event);
    } else if (event is RefreshPosts) {
      yield* _mapRefreshPostsEventToState(event);
    } else if (event is AddPost) {
      _analytics.logEvent(name: Constants.EVENT_SAVE_POST, parameters: {
        Constants.POST_PARAM_OWNER: event.post.owner,
      });
      yield* _mapAddPostEventToState(event);
    } else if (event is AddPostReaction) {
      _analytics.logEvent(name: Constants.EVENT_ADD_REACTION);
      yield* _mapAddPostReactionEventToState(event);
    } else if (event is RemovePostReaction) {
      _analytics.logEvent(name: Constants.EVENT_REMOVE_REACTION);
      yield* _mapRemovePostReactionEventToState(event);
    } else if (event is SyncPosts) {
      yield* _mapSyncPostsEventToState();
    } else if (event is SyncPostsCompleted) {
      yield* _mapSyncPostsCompletedEventToState(event);
    }
  }

  /// Initializes the posts stream subscription if it wasn't before
  void _initializeStreamListening() {
    if (_postsSubscription == null) {
      _postsSubscription = _getPostsUseCase.stream().listen((post) {
        // When we get new posts, simply reload the
        // currently shown list of posts
        add(LoadPosts());
      });
    }
  }

  /// Initializes the timer allowing us to sync the user activity once every
  /// [syncPeriod] seconds if it hasn't been done before.
  void _initializeSyncTimer() {
    if (_syncTimer?.isActive != true) {
      _syncTimer?.cancel();
      _syncTimer = Timer.periodic(Duration(seconds: _syncPeriod), (t) {
        add(SyncPosts());
      });
    }
  }

  /// Handles the event emitted when the posts list should be refreshed
  Stream<PostsState> _mapLoadPostsEventToState(LoadPosts event) async* {
    _initializeStreamListening();
    _initializeSyncTimer();

    final address = await _getAddressUseCase.get();

    final currentState = state;
    if (currentState is PostsLoaded) {
      // We have already loaded some posts
      final newPosts = await _getPostsUseCase.get();
      yield currentState.copyWith(posts: newPosts, address: address);
    } else {
      // We never loaded any post before
      final posts = await _getPostsUseCase.get(forceOnline: true);
      yield PostsLoaded(address: address, posts: posts);
    }
  }

  /// Handles the posts refresh event.
  Stream<PostsState> _mapRefreshPostsEventToState(RefreshPosts event) async* {
    final currentState = state;
    if (currentState is PostsLoaded) {
      yield currentState.copyWith(refreshing: true);
      final posts = await _getPostsUseCase.get(forceOnline: true);
      yield currentState.copyWith(refreshing: false, posts: posts);
    } else {
      yield currentState;
    }
  }

  /// Handles the event that is emitted when the user creates a new post
  Stream<PostsState> _mapAddPostEventToState(AddPost event) async* {
    final cState = state;
    if (cState is PostsLoaded) {
      final post = event.post;
      yield cState.copyWith(
        // Avoid to double show the new post
        posts: [post] + cState.posts.where((p) => p.id != post.id).toList(),
      );
    }
  }

  /// Handles the event emitted when the user likes a post
  Stream<PostsState> _mapAddPostReactionEventToState(
    AddPostReaction event,
  ) async* {
    if (state is PostsLoaded) {
      final updatedPost = await _addReactionToPostUseCase.react(
        event.postId,
        event.reaction,
      );
      final updatedPosts = (state as PostsLoaded)
          .posts
          .map((p) => p.id == updatedPost.id ? updatedPost : p)
          .toList();
      yield (state as PostsLoaded).copyWith(posts: updatedPosts);
    }
  }

  /// Handles the event telling that the user has unliked a previously
  /// liked post
  Stream<PostsState> _mapRemovePostReactionEventToState(
    RemovePostReaction event,
  ) async* {
    if (state is PostsLoaded) {
      final updatedPost = await _removeReactionFromPostUseCase.remove(
        event.postId,
        event.reaction,
      );
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
