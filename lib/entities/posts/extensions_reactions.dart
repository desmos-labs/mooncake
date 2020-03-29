import 'package:mooncake/entities/entities.dart';

/// Represents a set of extensions that are useful when dealing with
/// a list of reactions and having the need of performing some specific
/// operations such as controlling the existence of a reaction or
/// adding/removing one.
extension ReactionsExt on List<Reaction> {
  /// Returns `true` if this list of reactions already contains one having
  /// the specified [reactionCode] from the specified [account].
  bool containsFrom(MooncakeAccount account, String reactionCode) {
    return this.where((element) {
      return element.user.address == account.cosmosAccount.address &&
          element.code == reactionCode;
    }).isNotEmpty;
  }

  /// Given `this` list of reactions, performs one of the two operations:
  ///
  /// 1. If a reaction from the specified [account] and having the given
  ///   [value] already exists, then it removes it from the list.
  /// 2. If a reaction from the specified [account] and having the given
  ///   [value] is not yet preset, it adds it to the list.
  ///
  /// Once that either one of the two above operations have been performed,
  /// returned the updated list.
  List<Reaction> removeOrAdd(MooncakeAccount account, String reaction) {
    List<Reaction> reactions = this;
    if (containsFrom(account, reaction)) {
      reactions = _removeFrom(account, reaction);
    } else {
      reactions = _addFrom(account, reaction);
    }
    return reactions;
  }

  List<Reaction> _removeFrom(MooncakeAccount account, String reactionCode) {
    return this.where((element) {
      return element.user.address != account.cosmosAccount.address ||
          element.code != reactionCode;
    }).toList();
  }

  List<Reaction> _addFrom(MooncakeAccount account, String reactionCode) {
    return this + [Reaction(user: account.toUser(), code: reactionCode)];
  }
}
