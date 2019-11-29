import 'dart:async';

import 'package:desmosdemo/models/models.dart';
import 'package:desmosdemo/sources/sources.dart';
import 'package:flutter/cupertino.dart';

import '../models/models.dart';
import 'repositories.dart';

/// Represents the repository that can be used in order to read
/// and write data related to posts, comments and likes.
class PostsRepository {
  final LocalPostsSource _localSource;
  final RemotePostsSource _remotePostsSource;
  final UserRepository _userRepository;

  // TODO: We should probably cancel this
  // ignore: cancel_subscriptions
  StreamSubscription _postsSubscription;
  final StreamController<Post> _postsStream = StreamController();

  PostsRepository({
    @required LocalPostsSource localSource,
    @required RemotePostsSource remoteSource,
    @required UserRepository userRepository,
  })  : assert(localSource != null),
        assert(userRepository != null),
        _localSource = localSource,
        _remotePostsSource = remoteSource,
        _userRepository = userRepository;

  /// Saves the given post locally, also updating any existing parent's
  /// comments array to include this post.
  Future<void> _savePost(Post post) async {
    // Save the post
    await _localSource.savePost(post);

    // Update the parent comments
    Post parent = await _localSource.getPost(post.parentId);
    if (parent != null) {
      parent = parent.copyWith(commentsIds: [post.id] + parent.commentsIds);
      await _localSource.savePost(parent);
    }
  }

  /// Creates a new post having the given [message], [parentId] and
  /// [allowsComments] saving it inside the local cache so that is can
  /// be later sent to the chain.
  Future<void> createPost(
    String message, {
    @required String parentId,
    bool allowsComments = true,
  }) async {
    final user = await _userRepository.getUser();
    final date = DateTime.now().toIso8601String();
    final post = Post(
      id: date,
      parentId: parentId,
      message: message,
      created: "-1",
      lastEdited: "-1",
      allowsComments: allowsComments,
      owner: user,
      likes: [],
      commentsIds: [],
      synced: false,
    );
    await _savePost(post);
  }

  /// Returns a [Stream] that emits new posts each time they
  /// are fetched from the blockchain and stored inside the
  /// device.
  Stream<Post> get postsStream {
    if (_postsSubscription == null) {
      print("Initializing repository stream");
      _postsSubscription = _remotePostsSource.postsStream.listen((post) async {
        await _localSource.savePost(post);
        _postsStream.add(post);
      });
    }
    return _postsStream.stream;
  }

  /// Returns the full list of posts available.
  Future<List<Post>> getPosts() async {
    return _localSource.getPosts();
  }

  /// Returns all the comments details for the post having the given [postId].
  Future<List<Post>> getCommentsForPost(String postId) async {
    final post = await _localSource.getPost(postId);
    return Future.wait(post.commentsIds
        .map((commentId) => _localSource.getPost(commentId))
        .where((p) => p != null));
  }

  /// Checks if a like from this user already exists for the provided [post].
  /// If it exists, it does nothing.
  /// Otherwise, updates the posts, stores it and returns it.
  Future<Post> likePost(String postId) async {
    // Save the like
    await _localSource.likePost(postId);

    // Get the user and the post data
    final user = await _userRepository.getUser();
    Post post = await _localSource.getPost(postId);

    // Update the post if the like is not present
    if (!post.containsLikeFromUser(user.address)) {
      final like = Like(owner: user.address);
      post = post.copyWith(likes: [like] + post.likes);
      await _localSource.savePost(post);
    }

    return post;
  }

  /// Checks if a like from this user exists for the provided [post].
  /// If it exists, it removes it from the list and stores locally a reference
  /// so that a new transaction unliking the post will be performed later.
  /// If the like does not exist, does nothing.
  /// In both cases, returns the updated post.
  Future<Post> unlikePost(String postId) async {
    // Remove the like
    await _localSource.unlikePost(postId);

    // Get the user and the post data
    final user = await _userRepository.getUser();
    Post post = await _localSource.getPost(postId);

    // Update the post if the like exists
    if (post.containsLikeFromUser(user.address)) {
      final likes =
          post.likes.where((like) => like.owner != user.address).toList();
      post = post.copyWith(likes: likes);
      await _localSource.savePost(post);
    }

    return post;
  }

  /// Syncs all the user activities performing the correct transactions
  /// on the blockchain.
  Future<void> syncActivities() async {
    // TODO: List all the posts to be uploaded, and set their status as "In sync"
    // In this way we can later know which one should be locally updated even
    // if there are new posts being created in the mean time.
    // We should also skip posts with the same text as one already handled
    // and upload them at the next iteration.

    // Send the like and unlike transactions
    final postsToLikeIds = await _localSource.getPostsToLikeIds();
    final postsToUnlikeIds = await _localSource.getPostsToUnlikeIds();
    await _remotePostsSource.updateLikesAndUnlikes(
      postsToLikeIds,
      postsToUnlikeIds,
    );
  }
}
