import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/dependency_injection/dependency_injection.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/usecases/usecases.dart';

import '../export.dart';

/// Implementation of [Bloc] that allows to properly deal with
/// events and states related to the list of posts.
class PostsListBloc extends Bloc<PostsListEvent, PostsListState> {
  static const _HOME_LIMIT = 50;

  // Synchronization
  final int _syncPeriod;
  final SyncPostsUseCase _syncPostsUseCase;
  Timer _syncTimer;

  // Use cases
  final GetHomePostsUseCase _getHomePostsUseCase;
  final GetHomeEventsUseCase _getHomeEventsUseCase;
  final UpdatePostsStatusUseCase _updatePostsStatusUseCase;
  final ManagePostReactionsUseCase _managePostReactionsUseCase;

  // Subscriptions
  StreamSubscription _eventsSubscription;
  StreamSubscription _postsSubscription;
  StreamSubscription _txSubscription;

  PostsListBloc({
    @required int syncPeriod,
    @required FirebaseAnalytics analytics,
    @required GetHomePostsUseCase getHomePostsUseCase,
    @required GetHomeEventsUseCase getHomeEventsUseCase,
    @required SyncPostsUseCase syncPostsUseCase,
    @required GetNotificationsUseCase getNotificationsUseCase,
    @required UpdatePostsStatusUseCase updatePostsStatusUseCase,
    @required ManagePostReactionsUseCase managePostReactionsUseCase,
  })  : _syncPeriod = syncPeriod,
        assert(getHomePostsUseCase != null),
        _getHomePostsUseCase = getHomePostsUseCase,
        assert(getHomeEventsUseCase != null),
        _getHomeEventsUseCase = getHomeEventsUseCase,
        assert(syncPostsUseCase != null),
        _syncPostsUseCase = syncPostsUseCase,
        assert(updatePostsStatusUseCase != null),
        _updatePostsStatusUseCase = updatePostsStatusUseCase,
        assert(managePostReactionsUseCase != null),
        _managePostReactionsUseCase = managePostReactionsUseCase {
    _initializeSyncTimer();

    // Subscribe to the posts changes
    _postsSubscription =
        _getHomePostsUseCase.stream(_HOME_LIMIT).listen((posts) {
      add(PostsUpdated(posts));
    });

    // Subscribe to tell the user he should refresh
    _eventsSubscription = _getHomeEventsUseCase.stream.listen((event) {
      add(ShouldRefreshPosts());
    });

    // Subscribe to the transactions notifications
    _txSubscription = getNotificationsUseCase.stream().listen((notification) {
      if (notification is TxSuccessfulNotification) {
        add(TxSuccessful(txHash: notification.txHash));
      } else if (notification is TxFailedNotification) {
        add(TxFailed(txHash: notification.txHash, error: notification.error));
      }
    });
  }

  factory PostsListBloc.create({int syncPeriod = 30}) {
    return PostsListBloc(
      syncPeriod: syncPeriod,
      getHomePostsUseCase: Injector.get(),
      getHomeEventsUseCase: Injector.get(),
      syncPostsUseCase: Injector.get(),
      analytics: Injector.get(),
      getNotificationsUseCase: Injector.get(),
      updatePostsStatusUseCase: Injector.get(),
      managePostReactionsUseCase: Injector.get(),
    );
  }

  @override
  PostsListState get initialState => PostsLoading();

  @override
  Stream<PostsListState> mapEventToState(PostsListEvent event) async* {
    if (event is PostsUpdated) {
      yield* _mapPostsUpdatedEventToState(event);
    } else if (event is AddOrRemoveLike) {
      yield* _convertAddOrRemoveLikeEvent(event);
    } else if (event is AddOrRemovePostReaction) {
      yield* _mapAddPostReactionEventToState(event);
    } else if (event is SyncPosts) {
      yield* _mapSyncPostsListEventToState();
    } else if (event is SyncPostsCompleted) {
      yield* _mapSyncPostsCompletedEventToState();
    } else if (event is ShouldRefreshPosts) {
      yield* _mapShouldRefreshPostsEventToState();
    } else if (event is RefreshPosts) {
      yield* _refreshPostsEventToState();
    } else if (event is TxSuccessful) {
      _handleTxSuccessfulEvent(event);
    } else if (event is TxFailed) {
      _handleTxFailedEvent(event);
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

  /// Handles the event emitted when a new list of posts has been emitted.
  Stream<PostsListState> _mapPostsUpdatedEventToState(
    PostsUpdated event,
  ) async* {
    final currentState = state;
    if (currentState is PostsLoading) {
      yield PostsLoaded.first(posts: event.posts);
    } else if (currentState is PostsLoaded) {
      yield currentState.copyWith(
        posts: event.posts,
        refreshing: false,
        shouldRefresh: false,
      );
    }
  }

  /// Converts an [AddOrRemoveLikeEvent] into an
  /// [AddOrRemovePostReaction] event so that it can be handled properly.
  Stream<PostsListState> _convertAddOrRemoveLikeEvent(AddOrRemoveLike event) {
    final reactEvent = AddOrRemovePostReaction(
      event.post,
      Constants.LIKE_REACTION,
    );
    return _mapAddPostReactionEventToState(reactEvent);
  }

  /// Handles the event emitted when the user likes a post
  Stream<PostsListState> _mapAddPostReactionEventToState(
    AddOrRemovePostReaction event,
  ) async* {
    final currentState = state;
    if (currentState is PostsLoaded) {
      final newPost = await _managePostReactionsUseCase.addOrRemove(
        post: event.post,
        reaction: event.reactionCode,
      );
      final posts = currentState.posts
          .map((post) => post.id == newPost.id ? newPost : post)
          .toList();
      yield currentState.copyWith(posts: posts);
    }
  }

  Stream<PostsListState> _mapShouldRefreshPostsEventToState() async* {
    final currentState = state;
    if (currentState is PostsLoaded) {
      yield currentState.copyWith(shouldRefresh: true);
    }
  }

  /// Handles the event emitted when the list of the home posts
  /// should be updated.
  Stream<PostsListState> _refreshPostsEventToState() async* {
    final currentState = state;
    if (currentState is PostsLoaded) {
      yield currentState.copyWith(refreshing: true, shouldRefresh: false);
    }
    await _getHomePostsUseCase.refresh(_HOME_LIMIT);
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

  /// Handles the event that tells the Bloc that a transaction has
  /// been successful.
  void _handleTxSuccessfulEvent(TxSuccessful event) async {
    final status = PostStatus(
      value: PostStatusValue.TX_SUCCESSFULL,
      data: event.txHash,
    );
    await _updatePostsStatusUseCase.update(event.txHash, status);
  }

  /// Handles the event that tells the Bloc that a transaction has not
  /// been successful.
  void _handleTxFailedEvent(TxFailed event) async {
    final status = PostStatus(
      value: PostStatusValue.ERRORED,
      data: event.error,
    );
    await _updatePostsStatusUseCase.update(event.txHash, status);
  }

  @override
  Future<void> close() {
    _eventsSubscription?.cancel();
    _postsSubscription?.cancel();
    _txSubscription?.cancel();
    _syncTimer?.cancel();
    return super.close();
  }
}
