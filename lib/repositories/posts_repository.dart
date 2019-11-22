import 'dart:math';

import 'package:desmosdemo/models/models.dart';

class PostsRepository {
  const PostsRepository();

  Future<List<Post>> loadPosts() async {
    final addresses = [
      "cosmos1gcrpl9f9uwap4f2a9fargwyw9ers6ufnyge22y",
      "cosmos15s39pvs5aa4ys8pztr9kgk8sqwcanx6960c646",
      "cosmos1zgvl0dj5sqa3dshyr4hxyjveuwcx7k04hqd9um",
      "cosmos1fzntpsrmp6mwr6sv4q7e3ax6hkyvz88u0jpa9d",
      "cosmos1jvz7pqnfqeue860wpufc23j6nux6zaqlwsmasm",
    ];

    final random = new Random();

    return List.generate(
      100,
      (index) => Post(
        id: "$index",
        parentId: "0",
        message: "This is a super long post that should be wrapped properly",
        created: "0",
        lastEdited: "0",
        allowsComments: false,
        owner: addresses[random.nextInt(addresses.length)],
        likes: [],
        liked: random.nextBool(),
        children: [],
      ),
    );
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
