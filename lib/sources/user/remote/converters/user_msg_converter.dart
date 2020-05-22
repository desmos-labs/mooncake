import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/sources/sources.dart';

/// Allows to convert a [MooncakeAccount] into a [StdMsg] object.
class UserMsgConverter {
  /// Converts the given [local] account to a [MsgCreateProfile] object.
  MsgCreateProfile _toMsgCreateAccount(MooncakeAccount local) {
    final hasOnePicture =
        local.coverPicUri != null || local.profilePicUri != null;

    return MsgCreateProfile(
      moniker: local.moniker?.trim(),
      name: local.name,
      surname: local.surname,
      bio: local.bio,
      pictures: !hasOnePicture
          ? null
          : UserPictures(
              cover: local.coverPicUri,
              profile: local.profilePicUri,
            ),
      creator: local.address,
    );
  }

  /// Converts the given [local] account into a [MsgEditProfile]
  MsgEditProfile _toMsgEditAccount(MooncakeAccount local) {
    return MsgEditProfile(
      moniker: local.moniker?.trim(),
      name: local.name,
      surname: local.surname,
      bio: local.bio,
      profilePicture: local.profilePicUri,
      coverPicture: local.coverPicUri,
      creator: local.address,
    );
  }

  /// Takes the given [local] and [remote] accounts, and transforms them
  /// into either a [MsgCreateProfile] or [MsgEditProfile] object.
  StdMsg toUserMsg(MooncakeAccount local, MooncakeAccount existing) {
    if (existing?.moniker == null) {
      return _toMsgCreateAccount(local);
    }

    return _toMsgEditAccount(local);
  }
}
