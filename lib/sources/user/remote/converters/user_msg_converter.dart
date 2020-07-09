import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/sources/sources.dart';

/// Allows to convert a [MooncakeAccount] into a [StdMsg] object.
class UserMsgConverter {
  /// Takes the given [local] and [remote] accounts, and transforms them
  /// into either a [MsgSaveProfile].
  StdMsg toUserMsg(MooncakeAccount local) {
    return MsgSaveProfile(
      dtag: local.dtag,
      moniker: local.moniker,
      bio: local.bio,
      profilePic: local.profilePicUri,
      coverPic: local.coverPicUri,
      creator: local.address,
    );
  }
}
