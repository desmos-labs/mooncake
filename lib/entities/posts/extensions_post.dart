import 'package:mooncake/entities/entities.dart';

/// Defines a set of utility extensions on the [Post] type.
extension PollExt on Post {
  /// Tells whether or not the given [account] has voted on the poll contained
  /// inside this post.
  bool hasVoted(MooncakeAccount account) {
    return this.poll.userAnswers.any(
        (element) => element.user.address == account.cosmosAccount.address);
  }
}
