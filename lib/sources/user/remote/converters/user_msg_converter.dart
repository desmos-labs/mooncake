import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/sources/sources.dart';

/// Allows to convert a [MooncakeAccount] into a [StdMsg] object.
class UserMsgConverter {
  /// Converts the given [local] account to a [MsgCreateAccount] object.
  MsgCreateAccount _toMsgCreateAccount(MooncakeAccount local) {
    final hasOnePicture =
        local.coverPicUrl != null || local.profilePicUrl != null;

    return MsgCreateAccount(
      moniker: local.moniker?.trim(),
      name: local.name,
      surname: local.surname,
      bio: local.bio,
      pictures: !hasOnePicture
          ? null
          : UserPictures(
              cover: local.coverPicUrl,
              profile: local.profilePicUrl,
            ),
      creator: local.address,
    );
  }

  /// Converts the given [local] account into a [MsgEditAccount]
  MsgEditAccount _toMsgEditAccount(MooncakeAccount local) {
    return MsgEditAccount(
      moniker: local.moniker?.trim(),
      name: local.name,
      surname: local.surname,
      bio: local.bio,
      profilePicture: local.profilePicUrl,
      coverPicture: local.coverPicUrl,
      creator: local.address,
    );
  }

  /// Takes the given [local] and [remote] accounts, and transforms them
  /// into either a [MsgCreateAccount] or [MsgEditAccount] object.
  StdMsg toUserMsg(MooncakeAccount local, MooncakeAccount existing) {
    if (existing?.moniker == null) {
      return _toMsgCreateAccount(local);
    }

    return _toMsgEditAccount(local);
  }
}
