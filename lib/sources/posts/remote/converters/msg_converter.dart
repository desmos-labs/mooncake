import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/sources/sources.dart';

/// Contains the data of a reaction that should be added or removed from a post.
class ReactionData {
  final String postId;
  final String value;

  ReactionData({@required this.postId, @required this.value});
}

/// Allows to convert data into messages that can be sent to the chain.
class MsgConverter {
  /// Converts the given [post] into a [MsgCreatePost] allowing it
  /// to store such post into the chain.
  MsgCreatePost toMsgCreatePost(Post post, String creator) {
    return MsgCreatePost(
      parentId: post.parentId ?? "0",
      message: post.message ?? "",
      allowsComments: post.allowsComments,
      optionalData:
          post.optionalData?.isNotEmpty == true ? post.optionalData : null,
      subspace: post.subspace,
      creator: creator,
      creationDate: post.created,
      medias: post.medias?.isNotEmpty == true ? post.medias : null,
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
    final List<ReactionData> reactionsToAdd = [];
    final List<ReactionData> reactionsToRemove = [];
    for (int index = 0; index < posts.length; index++) {
      final post = posts[index];
      final existingPost = existingPosts[index];

      // The post needs to be created
      if (existingPost == null) {
        postsToCreate.add(posts[index]);
        continue;
      }

      // Iterate over the existing reactions to find the ones that have been
      // deleted
      for (final exReaction in existingPost.reactions) {
        if (!post.reactions.contains(exReaction)) {
          reactionsToRemove.add(ReactionData(
            postId: post.id,
            value: exReaction.code,
          ));
        }
      }

      // Iterate over the local reactions to find the ones that have been
      // added new
      for (final localReaction in post.reactions) {
        if (!existingPost.reactions.contains(localReaction)) {
          reactionsToAdd.add(
            ReactionData(postId: post.id, value: localReaction.code),
          );
        }
      }
    }

    final List<StdMsg> messages = [];
    messages.addAll(postsToCreate
        .map((post) => toMsgCreatePost(post, wallet.bech32Address))
        .toList());

    messages.addAll(reactionsToAdd
        .map((reaction) => MsgAddPostReaction(
              postId: reaction.postId,
              user: wallet.bech32Address,
              reaction: reaction.value,
            ))
        .toList());

    messages.addAll(reactionsToRemove
        .map((reaction) => MsgRemovePostReaction(
              postId: reaction.postId,
              user: wallet.bech32Address,
              reaction: reaction.value,
            ))
        .toList());

    return messages;
  }
}
