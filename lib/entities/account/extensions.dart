import 'package:mooncake/entities/entities.dart';

extension AccountExtensions on MooncakeAccount {
  bool hasLiked(Post post) {
    return hasReactedWith(post, Constants.LIKE_REACTION);
  }

  bool hasReactedWith(Post post, String reaction) {
    return post.reactions
        .where((react) =>
            react.value == reaction &&
            react.user.address == this.cosmosAccount.address)
        .isNotEmpty;
  }
}
