import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';

part 'msg_edit_profile.g.dart';

/// Represents the message to be used when the user wants to
/// create a new account.
@immutable
@reflector
@JsonSerializable(explicitToJson: true)
class MsgEditProfile extends StdMsg {
  @JsonKey(name: "new_moniker", includeIfNull: false)
  final String moniker;

  @JsonKey(name: "name", includeIfNull: false)
  final String name;

  @JsonKey(name: "surname", includeIfNull: false)
  final String surname;

  @JsonKey(name: "bio", includeIfNull: false)
  final String bio;

  @JsonKey(name: "profile_pic", includeIfNull: false)
  final String profilePicture;

  @JsonKey(name: "profile_cov", includeIfNull: false)
  final String coverPicture;

  @JsonKey(name: "creator")
  final String creator;

  MsgEditProfile({
    @required this.moniker,
    this.name,
    this.surname,
    this.bio,
    this.profilePicture,
    this.coverPicture,
    this.creator,
  })  : assert(moniker != null && moniker.trim().isNotEmpty),
        assert(creator != null && creator.trim().isNotEmpty),
        assert(name == null || name.trim().isNotEmpty),
        assert(surname == null || surname.trim().isNotEmpty),
        assert(bio == null || bio.trim().isNotEmpty);

  factory MsgEditProfile.fromJson(Map<String, dynamic> json) {
    return _$MsgEditProfileFromJson(json);
  }

  @override
  Map<String, dynamic> asJson() {
    return _$MsgEditProfileToJson(this);
  }

  @override
  List<Object> get props {
    return [
      moniker,
      name,
      surname,
      bio,
      profilePicture,
      coverPicture,
      creator,
    ];
  }

  @override
  Exception validate() {
    if (name != null && (name.length < 2 || name.length > 500)) {
      return Exception("Invalid name length. Should be between 2 and 500");
    }

    if (surname != null && (surname.length < 2 || surname.length > 500)) {
      return Exception("Invalid surname length. Should be between 2 and 500");
    }

    if (moniker == null || moniker.trim().isEmpty) {
      return Exception("moniker cannot be empty");
    }

    if (moniker.length > 30) {
      return Exception("moniker length cannot be more than 30 characters");
    }

    if (bio != null && bio.length > 1000) {
      return Exception("bio length cannot be longer than 1000 chars");
    }

    return null;
  }
}
