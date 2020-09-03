import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';

part 'msg_save_profile.g.dart';

/// Represents the message to be used when the user wants to
/// create a new account.
@immutable
@reflector
@JsonSerializable(explicitToJson: true)
class MsgSaveProfile extends StdMsg {
  @JsonKey(name: 'dtag')
  final String dtag;

  @JsonKey(name: 'moniker')
  final String moniker;

  @JsonKey(name: 'bio', includeIfNull: false)
  final String bio;

  @JsonKey(name: 'profile_picture', includeIfNull: false)
  final String profilePic;

  @JsonKey(name: 'cover_picture', includeIfNull: false)
  final String coverPic;

  @JsonKey(name: 'creator')
  final String creator;

  MsgSaveProfile({
    @required this.dtag,
    this.moniker,
    this.bio,
    this.profilePic,
    this.coverPic,
    @required this.creator,
  })  : assert(dtag != null && dtag.trim().isNotEmpty),
        assert(moniker == null || moniker.trim().isNotEmpty),
        assert(bio == null || bio.trim().isNotEmpty),
        assert(profilePic == null || profilePic.trim().isNotEmpty),
        assert(coverPic == null || profilePic.trim().isNotEmpty),
        assert(creator != null && creator.trim().isNotEmpty);

  factory MsgSaveProfile.fromJson(Map<String, dynamic> json) {
    return _$MsgSaveProfileFromJson(json);
  }

  @override
  Map<String, dynamic> asJson() {
    return _$MsgSaveProfileToJson(this);
  }

  @override
  List<Object> get props {
    return [
      dtag,
      moniker,
      bio,
      profilePic,
      coverPic,
      creator,
    ];
  }

  @override
  Exception validate() {
    if (dtag == null || dtag.trim().isEmpty) {
      return Exception('dtag cannot be empty');
    }

    return null;
  }
}
