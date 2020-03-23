import 'package:mooncake/entities/entities.dart';

extension ReactionsExt on List<Reaction> {
  bool containsFrom(MooncakeAccount account, String reactionCode) {
    return this.where((element) {
      return element.user.address == account.cosmosAccount.address &&
          element.code == reactionCode;
    }).isNotEmpty;
  }

  List<Reaction> removeOrAdd(MooncakeAccount account, String reaction) {
    List<Reaction> reactions = this;
    if (containsFrom(account, reaction)) {
      reactions = removeFrom(account, reaction);
    } else {
      reactions = addFrom(account, reaction);
    }
    return reactions;
  }

  List<Reaction> removeFrom(
    MooncakeAccount account,
    String reactionCode,
  ) {
    return this.where((element) {
      return element.user.address != account.cosmosAccount.address ||
          element.code != reactionCode;
    }).toList();
  }

  List<Reaction> addFrom(MooncakeAccount account, String reactionCode) {
    return this + [Reaction(user: account.toUser(), code: reactionCode)];
  }
}
