import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/dependency_injection/dependency_injection.dart';
import 'package:mooncake/usecases/usecases.dart';
import 'package:rxdart/rxdart.dart';

import '../export.dart';

/// Implementation of [Bloc] that allows to properly deal with
/// events and states related to the list of posts.
class PostsListBloc extends Bloc<PostsListEvent, PostsListState> {
  // Synchronization
  final int _syncPeriod;
  final SyncPostsUseCase _syncPostsUseCase;
  Timer _syncTimer;

  // Subscriptions
  StreamSubscription _userSubscription;
  StreamSubscription _postsSubscription;

  PostsListBloc({
    @required int syncPeriod,
    @required GetPostsUseCase getPostsUseCase,
    @required SyncPostsUseCase syncPostsUseCase,
    @required GetUserUseCase getUserUseCase,
    @required FirebaseAnalytics analytics,
  })  : _syncPeriod = syncPeriod,
        assert(getPostsUseCase != null),
        assert(syncPostsUseCase != null),
        _syncPostsUseCase = syncPostsUseCase,
        assert(getUserUseCase != null) {
    _initializeSyncTimer();

    // Subscribe to the user changes
    _userSubscription = getUserUseCase.stream().listen((user) {
      add(UserUpdated(user));
    });

    // Subscribe to the posts changes
    _postsSubscription = getPostsUseCase.stream().listen((posts) {
      add(PostsUpdated(posts));
    });
  }

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
    if (event is UserUpdated) {
      yield* _mapUserUpdatedEventToState(event);
    } else if (event is PostsUpdated) {
      yield* _mapPostsUpdatedEventToState(event);
    } else if (event is AddOrRemovePostReaction) {
      // TODO: Handle AddOrRemovePostReaction event
    } else if (event is SyncPosts) {
      yield* _mapSyncPostsListEventToState();
    } else if (event is SyncPostsCompleted) {
      yield* _mapSyncPostsCompletedEventToState();
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

  /// Handles the event emitted when the user has been updated.
  Stream<PostsListState> _mapUserUpdatedEventToState(UserUpdated event) async* {
    final currentState = state;
    if (currentState is PostsLoading) {
      yield PostsLoaded.first(user: event.user);
    } else if (currentState is PostsLoaded) {
      yield currentState.copyWith(user: event.user);
    }
  }

  /// Handles the event emitted when a new list of posts has been emitted.
  Stream<PostsListState> _mapPostsUpdatedEventToState(
    PostsUpdated event,
  ) async* {
    final currentState = state;
    if (currentState is PostsLoading) {
      yield PostsLoaded.first(posts: event.posts);
    } else if (currentState is PostsLoaded) {
      yield currentState.copyWith(posts: event.posts);
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
  Stream<PostsListState> _mapSyncPostsCompletedEventToState() async* {
    // Once the sync has been completed, hide the bar and load the new posts
    final currentState = state;
    if (currentState is PostsLoaded) {
      yield currentState.copyWith(syncingPosts: false);
    }
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    _postsSubscription?.cancel();
    _syncTimer?.cancel();
    return super.close();
  }
}
