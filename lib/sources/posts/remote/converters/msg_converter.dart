import 'package:desmosdemo/entities/entities.dart';
import 'package:desmosdemo/sources/sources.dart';
import 'package:meta/meta.dart';

/// Allows to convert data into messages that can be sent to the chain.
class MsgConverter {
  /// Converts the given [post] into a [MsgCreatePost] allowing it
  /// to store such post into the chain.
  MsgCreatePost toMsgCreatePost(Post post) {
    return MsgCreatePost(
      parentId: post.parentId ?? "0",
      message: post.message,
      allowsComments: post.allowsComments ?? false,
      externalReference: post.externalReference ?? "",
      creator: post.owner,
    );
  }

  /// Checks the [posts] and confronts it with [existingPosts] to get the
  /// proper [StdMsg] that should be sent to the chain in order to create or
  /// update the posts accordingly.
  List<StdMsg> convertPostsToMsg({
    @required List<Post> posts,
    @required List<Post> existingPosts,
    @required Wallet wallet,
  }) {
    // Divide the posts into the ones that need to be created, the
    // ones that need to be liked and the ones from which the like
    // should be removed.
    final List<Post> postsToCreate = [];
    final List<String> postsToLike = [];
    final List<String> postsToUnlike = [];
    for (int index = 0; index < posts.length; index++) {
      final post = posts[index];
      final existingPost = existingPosts[index];

      // The post needs to be created
      if (existingPost == null) {
        postsToCreate.add(posts[index]);
        continue;
      }

      final isPostLiked = post.containsLikeFromUser(wallet.bech32Address);
      final isExistingPostLiked =
          existingPost.containsLikeFromUser(wallet.bech32Address);

      // The user has liked this post
      if (isPostLiked && !isExistingPostLiked) {
        postsToLike.add(post.id);
        continue;
      }

      // The user has removed the like from this post
      if (isExistingPostLiked && !isPostLiked) {
        postsToUnlike.add(post.id);
        continue;
      }
    }

    final List<StdMsg> messages = [];
    messages
        .addAll(postsToCreate.map((post) => toMsgCreatePost(post)).toList());

    messages.addAll(postsToLike
        .map((id) => MsgLikePost(postId: id, liker: wallet.bech32Address))
        .toList());

    messages.addAll(postsToUnlike
        .map((id) => MsgUnLikePost(postId: id, liker: wallet.bech32Address))
        .toList());

    return messages;
  }
}
