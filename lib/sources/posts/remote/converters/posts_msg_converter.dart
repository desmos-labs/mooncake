import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/sources/sources.dart';

/// Contains the data of a reaction that should be added or removed from a post.
class ReactionData {
  final String postId;
  final String value;

  ReactionData({@required this.postId, @required this.value});
}

class AnswerData {
  final String postId;
  final List<String> answers;

  AnswerData({this.postId, this.answers});
}

/// Allows to convert data into messages that can be sent to the chain.
class PostsMsgConverter {
  ChainPollData _toChainPollData(PostPoll poll) {
    return ChainPollData(
      question: poll.question,
      endDate: poll.endDate,
      allowsMultipleAnswers: poll.allowsMultipleAnswers,
      allowsAnswerEdits: poll.allowsAnswerEdits,
      options: poll.options.map((e) {
        return (ChainPollOption(
          id: e.id.toString(),
          text: e.text,
        ));
      }).toList(),
    );
  }

  /// Converts the given [post] into a [MsgCreatePost] allowing it
  /// to store such post into the chain.
  MsgCreatePost _toMsgCreatePost(Post post, String creator) {
    return MsgCreatePost(
      parentId: post.parentId ?? '',
      message: post.message ?? '',
      allowsComments: post.allowsComments,
      optionalData:
          post.optionalData?.isNotEmpty == true ? post.optionalData : null,
      subspace: post.subspace,
      creator: creator,
      medias: post.medias?.isNotEmpty == true ? post.medias : null,
      poll: post.poll == null ? null : _toChainPollData(post.poll),
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
    final postsToCreate = <Post>[];
    final reactionsToAdd = <ReactionData>[];
    final reactionsToRemove = <ReactionData>[];
    final answersToAdd = <AnswerData>[];

    for (var index = 0; index < posts.length; index++) {
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
        if (!post.reactions.containsFromAddress(
          exReaction.user.address,
          exReaction.value,
        )) {
          reactionsToRemove.add(ReactionData(
            postId: post.id,
            value: exReaction.value,
          ));
        }
      }

      // Iterate over the local reactions to find the ones that have been
      // added new
      for (final localReaction in post.reactions) {
        if (!existingPost.reactions.containsFromAddress(
          localReaction.user.address,
          localReaction.value,
        )) {
          reactionsToAdd.add(ReactionData(
            postId: post.id,
            value: localReaction.value,
          ));
        }
      }

      // Iterate over the local poll answers to find the ones that have been
      // added new
      final localPoll = post.poll ?? PostPoll.empty();
      final existingPoll = existingPost.poll ?? PostPoll.empty();
      for (final localAnswer in localPoll.userAnswers) {
        if (!existingPoll.containsAnswerFrom(
          localAnswer.user.address,
          localAnswer.answer,
        )) {
          answersToAdd.add(AnswerData(
            postId: post.id,
            answers: [localAnswer.answer.toString()],
          ));
        }
      }
    }

    final messages = <StdMsg>[];
    messages.addAll(postsToCreate
        .map((post) => _toMsgCreatePost(post, wallet.bech32Address))
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

    messages.addAll(answersToAdd
        .map((answer) => MsgAnswerPoll(
            postId: answer.postId,
            answers: answer.answers,
            user: wallet.bech32Address))
        .toList());

    return messages;
  }
}
