import 'package:mooncake/entities/entities.dart';

/// Defines a set of usesulf extensions on the [MooncakeAccount] data type.
extension AccountExtensions on MooncakeAccount {
  /// Tells whether or not this account has liked the given [post].
  bool hasLiked(Post post) {
    return post.reactions.containsFrom(this, Constants.LIKE_REACTION);
  }

  /// Tells whether this [MooncakeAccount] has voted on the given [poll] or not.
  int hasVoted(PostPoll poll) {
    List<PollAnswer> option = poll.userAnswers
        .where((answer) => answer.user.address == this.address)
        .toList();

    return option.isNotEmpty ? option[0].answer : null;
  }

  PollAnswer selectedPollOption(PostPoll poll) {
    List<PollAnswer> option = poll.userAnswers
        .where((answer) => answer.user.address == this.address)
        .toList();
    return option.isNotEmpty ? option[0] : null;
  }

  /// Transforms this instance of [MooncakeAccount] into a [User] instance.
  User toUser() {
    return User(
      address: this.address,
      dtag: this.dtag,
      moniker: this.moniker,
      bio: this.bio,
      profilePicUri: this.profilePicUri,
      coverPicUri: this.coverPicUri,
    );
  }
}
