import 'package:mooncake/entities/entities.dart';

extension AccountExtensions on MooncakeAccount {
  bool hasLiked(Post post) {
    return post.reactions.containsFrom(this, Constants.LIKE_REACTION);
  }

  User toUser() {
    return User.fromAddress(cosmosAccount.address);
  }
}
