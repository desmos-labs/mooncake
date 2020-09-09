import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/dependency_injection/dependency_injection.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:mooncake/usecases/usecases.dart';

import '../export.dart';

/// Implementation of [Bloc] that allows to properly deal with
/// events and states related to the list of posts.
class PostsListBloc extends Bloc<PostsListEvent, PostsListState> {
  static const _HOME_LIMIT = 25;

  // Synchronization
  final int _syncPeriod;
  final SyncPostsUseCase _syncPostsUseCase;
  Timer _syncTimer;

  // Use cases
  final GetNotificationsUseCase _getNotifications;
  final GetHomePostsUseCase _getHomePostsUseCase;
  final GetHomeEventsUseCase _getHomeEventsUseCase;
  final UpdatePostsStatusUseCase _updatePostsStatusUseCase;
  final ManagePostReactionsUseCase _managePostReactionsUseCase;
  final VotePollUseCase _votePollUseCase;
  final HidePostUseCase _hidePostUseCase;
  final DeletePostsUseCase _deletePostsUseCase;
  final BlockUserUseCase _blockUserUseCase;
  final UpdatePostUseCase _updatePostUseCase;
  final DeletePostUseCase _deletePostUseCase;
  final GetActiveAccountUseCase _getActiveAccountUseCase;

  // Subscriptions
  StreamSubscription _eventsSubscription;
  StreamSubscription _postsSubscription;
  StreamSubscription _txSubscription;
  StreamSubscription _logoutSubscription;

  PostsListBloc({
    @required int syncPeriod,
    @required AccountBloc accountBloc,
    @required FirebaseAnalytics analytics,
    @required GetHomePostsUseCase getHomePostsUseCase,
    @required GetHomeEventsUseCase getHomeEventsUseCase,
    @required SyncPostsUseCase syncPostsUseCase,
    @required GetNotificationsUseCase getNotificationsUseCase,
    @required UpdatePostsStatusUseCase updatePostsStatusUseCase,
    @required ManagePostReactionsUseCase managePostReactionsUseCase,
    @required HidePostUseCase hidePostUseCase,
    @required VotePollUseCase votePollUseCase,
    @required DeletePostsUseCase deletePostsUseCase,
    @required BlockUserUseCase blockUserUseCase,
    @required UpdatePostUseCase updatePostUseCase,
    @required DeletePostUseCase deletePostUseCase,
    @required GetActiveAccountUseCase getActiveAccountUseCase,
  })  : _syncPeriod = syncPeriod,
        assert(getNotificationsUseCase != null),
        _getNotifications = getNotificationsUseCase,
        assert(getHomePostsUseCase != null),
        _getHomePostsUseCase = getHomePostsUseCase,
        assert(getHomeEventsUseCase != null),
        _getHomeEventsUseCase = getHomeEventsUseCase,
        assert(syncPostsUseCase != null),
        _syncPostsUseCase = syncPostsUseCase,
        assert(updatePostsStatusUseCase != null),
        _updatePostsStatusUseCase = updatePostsStatusUseCase,
        assert(managePostReactionsUseCase != null),
        _managePostReactionsUseCase = managePostReactionsUseCase,
        assert(hidePostUseCase != null),
        _hidePostUseCase = hidePostUseCase,
        assert(votePollUseCase != null),
        _votePollUseCase = votePollUseCase,
        assert(deletePostsUseCase != null),
        _deletePostsUseCase = deletePostsUseCase,
        assert(blockUserUseCase != null),
        _blockUserUseCase = blockUserUseCase,
        assert(updatePostUseCase != null),
        _updatePostUseCase = updatePostUseCase,
        assert(deletePostUseCase != null),
        _deletePostUseCase = deletePostUseCase,
        assert(getActiveAccountUseCase != null),
        _getActiveAccountUseCase = getActiveAccountUseCase,
        super(PostsLoading()) {
    // Handle the last account state
    final accountState = accountBloc.state;
    _handleAccountStateChange(accountState);

    // Subscribe to account state changes in order to perform setup
    // operations upon login and cleanup ones upon logging out
    _logoutSubscription = accountBloc.listen((state) async {
      await _handleAccountStateChange(state);
    });
  }

  Future<void> _handleAccountStateChange(AccountState state) async {
    if (state is LoggedOut) {
      print('User logged out, stopping sync and deleting posts');
      _stopListeningToUpdates();
      await _deletePostsUseCase.delete();
    } else if (state is LoggedIn) {
      print('User logged in, starting posts sync');
      _startListeningToUpdates();
    }
  }

  factory PostsListBloc.create(BuildContext context, {int syncPeriod = 30}) {
    return PostsListBloc(
      syncPeriod: syncPeriod,
      accountBloc: BlocProvider.of(context),
      getHomePostsUseCase: Injector.get(),
      getHomeEventsUseCase: Injector.get(),
      syncPostsUseCase: Injector.get(),
      analytics: Injector.get(),
      getNotificationsUseCase: Injector.get(),
      updatePostsStatusUseCase: Injector.get(),
      managePostReactionsUseCase: Injector.get(),
      hidePostUseCase: Injector.get(),
      votePollUseCase: Injector.get(),
      deletePostsUseCase: Injector.get(),
      blockUserUseCase: Injector.get(),
      updatePostUseCase: Injector.get(),
      deletePostUseCase: Injector.get(),
      getActiveAccountUseCase: Injector.get(),
    );
  }

  @override
  Stream<Transition<PostsListEvent, PostsListState>> transformEvents(
    Stream<PostsListEvent> events,
    TransitionFunction<PostsListEvent, PostsListState> next,
  ) {
    return super.transformEvents(events.distinct(), next);
  }

  @override
  Stream<PostsListState> mapEventToState(PostsListEvent event) async* {
    final currentState = state;
    if (event is PostsUpdated) {
      yield* _mapPostsUpdatedEventToState(event);
    } else if (event is AddOrRemoveLike) {
      yield* _convertAddOrRemoveLikeEvent(event);
    } else if (event is AddOrRemovePostReaction) {
      yield* _mapAddPostReactionEventToState(event);
    } else if (event is VotePoll) {
      yield* _mapVotePollEventToState(event);
    } else if (event is HidePost) {
      yield* _mapHidePostEventToState(event);
    } else if (event is BlockUser) {
      yield* _mapBlockUserEventToState(event);
    } else if (event is SyncPosts) {
      yield* _mapSyncPostsListEventToState();
    } else if (event is SyncPostsCompleted) {
      yield _mapSyncPostsCompletedEventToState();
    } else if (event is ShouldRefreshPosts) {
      yield* _mapShouldRefreshPostsEventToState();
    } else if (event is RefreshPosts) {
      yield* _refreshPostsEventToState();
    } else if (event is FetchPosts && !_hasReachedMax(currentState)) {
      yield* _mapFetchEventToState();
    } else if (event is TxSuccessful) {
      _handleTxSuccessfulEvent(event);
    } else if (event is TxFailed) {
      _handleTxFailedEvent(event);
    } else if (event is DeletePosts) {
      _handleDeletePosts();
    } else if (event is RetryPostUpload) {
      yield* _mapRetryPostUploadEventToState(event);
    } else if (event is DeletePost) {
      yield* _mapDeletePostToState(event);
    }
  }

  /// Starts all the needed periodic operations (eg. sync) and
  /// the listening of all the useful events.
  void _startListeningToUpdates() {
    // Start the syncing timer
    _initializeSyncTimer();

    // Subscribe to the posts changes
    if (_postsSubscription == null) {
      _listenHomePosts(_HOME_LIMIT);
    }

    // Subscribe to tell the user he should refresh
    _eventsSubscription ??= _getHomeEventsUseCase.stream.listen((event) {
      add(ShouldRefreshPosts());
    });

    // Subscribe to the transactions notifications
    _txSubscription ??= _getNotifications.stream().listen((notification) {
      if (notification is TxSuccessfulNotification) {
        add(TxSuccessful(txHash: notification.txHash));
      } else if (notification is TxFailedNotification) {
        add(TxFailed(txHash: notification.txHash, error: notification.error));
      }
    });
  }

  /// Stop all periodic activities as well as all subscriptions.
  void _stopListeningToUpdates() {
    _syncTimer?.cancel();
    _syncTimer = null;

    _postsSubscription?.cancel();
    _postsSubscription = null;

    _eventsSubscription?.cancel();
    _eventsSubscription = null;

    _txSubscription?.cancel();
    _txSubscription = null;
  }

  /// Refreshes the subscription that listens to changes inside the number
  /// of home posts.
  void _listenHomePosts(int limit) {
    _postsSubscription?.cancel();
    _postsSubscription = _getHomePostsUseCase.stream(limit).listen((posts) {
      if (posts.isEmpty) return;
      add(PostsUpdated(posts));
    });
  }

  /// Tells whether all the posts have been fetched from the remote source
  /// or there are still some pages left.
  bool _hasReachedMax(PostsListState state) {
    return state is PostsLoaded && state.hasReachedMax;
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

  /// Merges the [current] posts list with the [newList].
  /// INVARIANT: `current.length > newList.length`
  List<Post> _mergePosts(List<Post> current, List<Post> newList) {
    final posts = current.map((post) {
      final newPost = newList.firstWhere(
        (p) => p.id == post.id,
        orElse: () => null,
      );
      return newPost ?? post;
    }).toList();

    return posts;
  }

  /// Handles the event emitted when a new list of posts has been emitted.
  Stream<PostsListState> _mapPostsUpdatedEventToState(
    PostsUpdated event,
  ) async* {
    final currentState = state;

    if (currentState is PostsLoading) {
      yield PostsLoaded.first(posts: event.posts);
    } else if (currentState is PostsLoaded) {
      // Avoid overloading operations
      if (currentState.posts == event.posts) {
        return;
      }

      yield currentState.copyWith(
        posts: event.posts.length < currentState.posts.length
            ? await _mergePosts(currentState.posts, event.posts)
            : event.posts,
        refreshing: false,
        shouldRefresh: false,
      );
    }
  }

  /// Converts an [AddOrRemoveLikeEvent] into an
  /// [AddOrRemovePostReaction] event so that it can be handled properly.
  Stream<PostsListState> _convertAddOrRemoveLikeEvent(
    AddOrRemoveLike event,
  ) {
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
        reaction: event.reaction,
      );
      final posts = currentState.posts
          .map((post) => post.id == newPost.id ? newPost : post)
          .toList();
      yield currentState.copyWith(posts: posts);
    }
  }

  /// Handles the event emitted when the user votes on a specific post poll.
  Stream<PostsListState> _mapVotePollEventToState(VotePoll event) async* {
    final currentState = state;
    if (currentState is PostsLoaded) {
      final newPost = await _votePollUseCase.vote(event.post, event.option);
      final newPosts = currentState.posts
          .map((post) => post.id == newPost.id ? newPost : post)
          .toList();
      yield currentState.copyWith(posts: newPosts);
    }
  }

  /// Handles the event emitted when a post should be hidden from the user view.
  Stream<PostsListState> _mapHidePostEventToState(
    HidePost event,
  ) async* {
    final currentState = state;
    if (currentState is PostsLoaded) {
      final newPost = await _hidePostUseCase.hide(event.post);
      final newPosts = currentState.posts
          .map((post) => post.id == newPost.id ? newPost : post)
          .toList();
      yield currentState.copyWith(posts: newPosts);
    }
  }

  /// Handles the event emitted when the user wants to block another user.
  Stream<PostsListState> _mapBlockUserEventToState(BlockUser event) async* {
    final currentState = state;
    if (currentState is PostsLoaded) {
      await _blockUserUseCase.block(event.user);
      final newPosts = currentState.posts
          .where((post) => post.owner.address != event.user.address)
          .toList();
      yield currentState.copyWith(posts: newPosts);
    }
  }

  Stream<PostsListState> _mapFetchEventToState() async* {
    final currentState = state;
    if (currentState is PostsLoading) {
      final posts = await _getHomePostsUseCase.get(
        start: 0,
        limit: _HOME_LIMIT,
      );
      yield PostsLoaded.first(posts: posts);
    } else if (currentState is PostsLoaded) {
      final posts = await _getHomePostsUseCase.get(
        start: currentState.posts.length,
        limit: _HOME_LIMIT,
      );
      yield posts.isEmpty
          ? currentState.copyWith(hasReachedMax: true)
          : currentState.copyWith(
              posts: currentState.posts + posts,
              hasReachedMax: false,
            );

      // Listen to new changes on all the posts
      if (posts.isNotEmpty) {
        _listenHomePosts(currentState.posts.length + posts.length);
      }
    }
  }

  /// Handles the event that is emitted when the list of posts should be
  /// refreshed.
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
    var limit = _HOME_LIMIT;
    if (currentState is PostsLoaded) {
      limit = currentState.posts.length;
      yield currentState.copyWith(refreshing: true, shouldRefresh: false);
    }

    final posts = await _getHomePostsUseCase.get(start: 0, limit: limit);
    if (currentState is PostsLoaded) {
      yield currentState.copyWith(
        refreshing: false,
        posts: posts,
        shouldRefresh: false,
      );
    } else if (currentState is PostsLoading) {
      yield PostsLoaded.first(posts: posts);
    }
  }

  /// Handles the event emitted when the posts must be synced uploading
  /// all the changes stored locally to the chain
  Stream<PostsListState> _mapSyncPostsListEventToState() async* {
    final currentState = state;
    if (currentState is PostsLoaded) {
      // Fet the current user
      final user = await _getActiveAccountUseCase.single();

      // Show the snackbar
      yield currentState.copyWith(syncingPosts: true);

      // Wait for the sync
      yield await _syncPostsUseCase.sync(user.address).catchError((error) {
        print('Sync error: $error');
        return _mapSyncPostsCompletedEventToState();
      }).then((syncedPosts) {
        return _mapSyncPostsCompletedEventToState();
      });
    }
  }

  /// Handles the event that tells the bloc the synchronization has completed
  PostsListState _mapSyncPostsCompletedEventToState() {
    // Once the sync has been completed, hide the bar and load the new posts
    final currentState = state;
    if (currentState is PostsLoaded) {
      return currentState.copyWith(syncingPosts: false);
    }
    return currentState;
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

  void _handleDeletePosts() async {
    await _deletePostsUseCase.delete();
    add(RefreshPosts());
  }

  /// Handles the event that is emitted when the user tries to repost
  /// a failed post attempt
  Stream<PostsListState> _mapRetryPostUploadEventToState(
    RetryPostUpload event,
  ) async* {
    final user = await _getActiveAccountUseCase.single();
    final updatePost = event.post.copyWith(
      status: PostStatus.storedLocally(user.address),
    );

    final currentState = state;
    if (currentState is PostsLoaded) {
      await _updatePostUseCase.update(updatePost);

      yield currentState.copyWith(
        posts: _mergePosts(currentState.posts, [updatePost]),
      );
    }
  }

  /// Handles the event that is emitted when the user wants to delete a failed post
  Stream<PostsListState> _mapDeletePostToState(DeletePost event) async* {
    final currentState = state;
    if (currentState is PostsLoaded) {
      await _deletePostUseCase.delete(event.post);
      yield currentState.copyWith(
          posts: currentState.posts
              .where((post) => post.id != event.post.id)
              .toList());
    }
  }

  @override
  Future<void> close() {
    _eventsSubscription?.cancel();
    _postsSubscription?.cancel();
    _txSubscription?.cancel();
    _syncTimer?.cancel();
    _logoutSubscription?.cancel();
    return super.close();
  }
}
