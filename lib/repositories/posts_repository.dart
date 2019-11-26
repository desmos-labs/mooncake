import 'dart:math';

import 'package:desmosdemo/models/models.dart';
import 'package:desmosdemo/sources/sources.dart';
import 'package:flutter/cupertino.dart';

import '../models/models.dart';
import '../models/models.dart';
import 'repositories.dart';
import 'repositories.dart';

/// Represents the repository that can be used in order to read
/// and write data related to posts, comments and likes.
class PostsRepository {
  final LocalPostsSource _localSource;
  final UserRepository _userRepository;

  const PostsRepository({
    @required LocalPostsSource localSource,
    @required UserRepository userRepository,
  })  : assert(localSource != null),
        assert(userRepository != null),
        _localSource = localSource,
        _userRepository = userRepository;

  /// Returns the full list of posts available.
  Future<List<Post>> loadPosts() async {
    return _localSource.getPosts();
  }

  /// Returns all the comments details for the post having the given [postId].
  Future<List<Post>> getCommentsForPost(String postId) async {
    final post = await _localSource.getPostById(postId);
    return Future.wait(post.commentsIds
        .map((comment) => _localSource.getPostById(comment))
        .where((p) => p != null));
  }

  /// Creates a new post having the given [message], returning it.
  Future<Post> createPost(String message) async {
    final user = await _userRepository.getUser();
    final date = DateTime.now().toIso8601String();
    return Post(
      id: date,
      parentId: "0",
      message: message,
      created: "-1",
      lastEdited: "-1",
      // TODO: Allow to set this
      allowsComments: true,
      owner: user,
      likes: [],
      commentsIds: [],
      synced: false,
    );
  }

  /// Saves the [updatedPosts] list into the local cache, that will later
  /// be used to determine which posts should be created using a blockchain
  /// transaction.
  Future<List<Post>> savePosts(List<Post> updatedPosts) async {
    return _localSource.savePosts(updatedPosts);
  }

  /// Checks if a like from this user already exists for the provided [post].
  /// If it exists, it does nothing and returns the current likes list for this
  /// post.
  /// Otherwise, it creates a new [Like] object, adds it to the cache of likes
  /// that needs to be sent to the blockchain and returns the updated list.
  Future<List<Like>> likePost(Post post) async {
    return [];
  }

  /// Checks if a like from this user exists for the provided [post]-
  /// If it exists, it removes it from the list and stores locally a reference
  /// so that a new transaction unliking the post will be performed later. After
  /// that it returns the updated list of likes for the post.
  /// If the like does not exist, returns the current list of likes for
  /// the post.
  Future<List<Like>> unlikePost(Post post) async {
    return [];
  }
}
