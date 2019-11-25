import 'dart:math';

import 'package:desmosdemo/models/models.dart';

/// Represents the repository that can be used in order to read
/// and write data related to posts, comments and likes.
class PostsRepository {
  const PostsRepository();

  /// Returns the full list of posts available.
  Future<List<Post>> loadPosts() async {
    final addresses = [
      "cosmos1gcrpl9f9uwap4f2a9fargwyw9ers6ufnyge22y",
      "cosmos15s39pvs5aa4ys8pztr9kgk8sqwcanx6960c646",
      "cosmos1zgvl0dj5sqa3dshyr4hxyjveuwcx7k04hqd9um",
      "cosmos1fzntpsrmp6mwr6sv4q7e3ax6hkyvz88u0jpa9d",
      "cosmos1jvz7pqnfqeue860wpufc23j6nux6zaqlwsmasm",
    ];

    final random = new Random();

    final comments = List.generate(
      20,
      (index) => Post(
        id: "comment-$index",
        parentId: "1",
        message: "Comment $index",
        created: "0",
        lastEdited: "0",
        allowsComments: false,
        owner: User(
          address: addresses[random.nextInt(addresses.length)],
          avatarUrl: null,
          username: null,
        ),
        likes: [],
        liked: random.nextBool(),
        commentsIds: [],
      ),
    ).toList();

    return comments +
        List.generate(
          100,
          (index) => Post(
            id: "post-$index",
            parentId: "0",
            message:
                "This is a super long post that should be wrapped properly",
            created: "0",
            lastEdited: "0",
            allowsComments: false,
            owner: User(
              address: addresses[random.nextInt(addresses.length)],
              avatarUrl: null,
              username: null,
            ),
            likes: [],
            liked: random.nextBool(),
            commentsIds:
                random.nextBool() ? comments.map((c) => c.id).toList() : [],
          ),
        );
  }

  /// Returns all the comments details for the post having the given [postId].
  Future<List<Post>> getCommentsForPost(String postId) async {
    final addresses = [
      "cosmos1gcrpl9f9uwap4f2a9fargwyw9ers6ufnyge22y",
      "cosmos15s39pvs5aa4ys8pztr9kgk8sqwcanx6960c646",
      "cosmos1zgvl0dj5sqa3dshyr4hxyjveuwcx7k04hqd9um",
      "cosmos1fzntpsrmp6mwr6sv4q7e3ax6hkyvz88u0jpa9d",
      "cosmos1jvz7pqnfqeue860wpufc23j6nux6zaqlwsmasm",
    ];

    final random = new Random();

    final comments = List.generate(
      20,
      (index) => Post(
        id: "comment-$index-$postId",
        parentId: "1",
        message: "Comment with id comment-$index-$postId",
        created: "0",
        lastEdited: "0",
        allowsComments: false,
        owner: User(
          address: addresses[random.nextInt(addresses.length)],
          avatarUrl: null,
          username: null,
        ),
        likes: [],
        liked: random.nextBool(),
        commentsIds: [],
      ),
    ).toList();

    return Future.delayed(Duration(seconds: 2), () {
      return comments;
    });
  }

  /// Saves the [updatedPosts] list into the local cache, that will later
  /// be used to determine which posts should be created using a blockchain
  /// transaction.
  Future savePosts(List<Post> updatedPosts) async {
    return;
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
