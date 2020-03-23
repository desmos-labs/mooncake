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
  // Synchronization
  final int _syncPeriod;
  final SyncPostsUseCase _syncPostsUseCase;
  Timer _syncTimer;

  // Use cases
  final UpdatePostsStatusUseCase _updatePostsStatusUseCase;
  final ManagePostReactionsUseCase _managePostReactionsUseCase;

  // Subscriptions
  StreamSubscription _userSubscription;
  StreamSubscription _postsSubscription;
  StreamSubscription _txSubscription;

  PostsListBloc({
    @required int syncPeriod,
    @required FirebaseAnalytics analytics,
    @required GetPostsUseCase getPostsUseCase,
    @required SyncPostsUseCase syncPostsUseCase,
    @required GetAccountUseCase getUserUseCase,
    @required GetNotificationsUseCase getNotificationsUseCase,
    @required UpdatePostsStatusUseCase updatePostsStatusUseCase,
    @required ManagePostReactionsUseCase managePostReactionsUseCase,
  })  : _syncPeriod = syncPeriod,
        assert(getPostsUseCase != null),
        assert(syncPostsUseCase != null),
        _syncPostsUseCase = syncPostsUseCase,
        assert(getUserUseCase != null),
        assert(updatePostsStatusUseCase != null),
        _updatePostsStatusUseCase = updatePostsStatusUseCase,
        assert(managePostReactionsUseCase != null),
        _managePostReactionsUseCase = managePostReactionsUseCase {
    _initializeSyncTimer();

    // Subscribe to the user changes
    _userSubscription = getUserUseCase.stream().listen((user) {
      add(UserUpdated(user));
    });

    // Subscribe to the posts changes
    _postsSubscription = getPostsUseCase.stream().listen((posts) {
      add(PostsUpdated(posts));
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
      getPostsUseCase: Injector.get(),
      syncPostsUseCase: Injector.get(),
      getUserUseCase: Injector.get(),
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
    if (event is UserUpdated) {
      yield* _mapUserUpdatedEventToState(event);
    } else if (event is PostsUpdated) {
      yield* _mapPostsUpdatedEventToState(event);
    } else if (event is AddOrRemoveLike) {
      _convertAddOrRemoveLikeEvent(event);
    } else if (event is AddOrRemovePostReaction) {
      yield* _mapAddPostReactionEventToState(event);
    } else if (event is SyncPosts) {
      yield* _mapSyncPostsListEventToState();
    } else if (event is SyncPostsCompleted) {
      yield* _mapSyncPostsCompletedEventToState();
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

  /// Converts an [AddOrRemoveLikeEvent] into an
  /// [AddOrRemovePostReaction] event so that it can be handled properly.
  void _convertAddOrRemoveLikeEvent(AddOrRemoveLike event) {
    add(AddOrRemovePostReaction(event.post, Constants.LIKE_REACTION));
  }

  /// Handles the event emitted when the user likes a post
  Stream<PostsListState> _mapAddPostReactionEventToState(
    AddOrRemovePostReaction event,
  ) async* {
    print("Add or remove: ${event.reactionCode}");
    await _managePostReactionsUseCase.addOrRemove(
      postId: event.post.id,
      reaction: event.reactionCode,
    );
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
    _userSubscription?.cancel();
    _postsSubscription?.cancel();
    _txSubscription?.cancel();
    _syncTimer?.cancel();
    return super.close();
  }
}
