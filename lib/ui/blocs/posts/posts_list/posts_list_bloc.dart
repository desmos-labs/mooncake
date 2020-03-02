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
class PostsListBloc extends Bloc<PostsListEvent, PostsListState> {
  final int _syncPeriod;

  final GetUserUseCase _getUserUseCase;

  final GetPostsUseCase _getPostsUseCase;
  final SyncPostsUseCase _syncPostsUseCase;
  final FirebaseAnalytics _analytics;

  Timer _syncTimer;
  StreamSubscription _postsSubscription;

  PostsListBloc({
    @required int syncPeriod,
    @required GetPostsUseCase getPostsUseCase,
    @required SyncPostsUseCase syncPostsUseCase,
    @required GetUserUseCase getUserUseCase,
    @required FirebaseAnalytics analytics,
  })  : _syncPeriod = syncPeriod,
        assert(getPostsUseCase != null),
        _getPostsUseCase = getPostsUseCase,
        assert(syncPostsUseCase != null),
        _syncPostsUseCase = syncPostsUseCase,
        assert(getUserUseCase != null),
        _getUserUseCase = getUserUseCase,
        assert(analytics != null),
        _analytics = analytics;

  factory PostsListBloc.create({int syncPeriod = 30}) {
    return PostsListBloc(
      syncPeriod: syncPeriod,
      getPostsUseCase: Injector.get(),
      syncPostsUseCase: Injector.get(),
      getUserUseCase: Injector.get(),
      analytics: Injector.get(),
    );
  }

  @override
  PostsListState get initialState => PostsLoading();

  @override
  Stream<PostsListState> mapEventToState(PostsListEvent event) async* {
    if (event is LoadPosts) {
      yield* _mapLoadPostsListEventToState(event);
    } else if (event is RefreshPosts) {
      yield* _mapRefreshPostsListEventToState(event);
    } else if (event is AddPost) {
      _analytics.logEvent(name: Constants.EVENT_SAVE_POST, parameters: {
        Constants.POST_PARAM_OWNER: event.post.owner,
      });
      yield* _mapAddPostEventToState(event);
    } else if (event is AddOrRemovePostReaction) {

    } else if (event is SyncPosts) {
      yield* _mapSyncPostsListEventToState();
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
  Stream<PostsListState> _mapLoadPostsListEventToState(LoadPosts event) async* {
    _initializeStreamListening();
    _initializeSyncTimer();

    final user = await _getUserUseCase.single();

    final currentState = state;
    if (currentState is PostsLoaded) {
      // We have already loaded some posts
      final newPosts = await _getPostsUseCase.get();
      yield currentState.copyWith(posts: newPosts, user: user);
    } else {
      // We never loaded any post before
      final posts = await _getPostsUseCase.get(forceOnline: true);
      yield PostsLoaded(user: user, posts: posts);
    }
  }

  /// Handles the posts refresh event.
  Stream<PostsListState> _mapRefreshPostsListEventToState(RefreshPosts event) async* {
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
  Stream<PostsListState> _mapAddPostEventToState(AddPost event) async* {
    final cState = state;
    if (cState is PostsLoaded) {
      final post = event.post;
      yield cState.copyWith(
        // Avoid to double show the new post
        posts: [post] + cState.posts.where((p) => p.id != post.id).toList(),
      );
    }
  }

  /// Handles the event emitted when the posts must be synced uploading
  /// all the changes stored locally to the chain
  Stream<PostsListState> _mapSyncPostsListEventToState() async* {
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
  Stream<PostsListState> _mapSyncPostsCompletedEventToState(
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
