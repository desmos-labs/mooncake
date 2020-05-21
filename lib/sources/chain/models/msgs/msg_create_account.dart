import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';

import 'user_pictures.dart';

part 'msg_create_account.g.dart';

/// Represents the message to be used when the user wants to
/// create a new account.
@immutable
@reflector
@JsonSerializable(explicitToJson: true)
class MsgCreateAccount extends StdMsg {
  @JsonKey(name: "moniker")
  final String moniker;

  @JsonKey(name: "name")
  final String name;

  @JsonKey(name: "surname")
  final String surname;

  @JsonKey(name: "bio")
  final String bio;

  @JsonKey(name: "pictures")
  final UserPictures pictures;

  @JsonKey(name: "creator")
  final String creator;

  MsgCreateAccount({
    @required this.moniker,
    this.name,
    this.surname,
    this.bio,
    this.pictures,
    this.creator,
  })  : assert(moniker != null && moniker.trim().isNotEmpty),
        assert(creator != null && creator.trim().isNotEmpty),
        assert(name == null || name.trim().isNotEmpty),
        assert(surname == null || surname.trim().isNotEmpty),
        assert(bio == null || bio.trim().isNotEmpty);

  factory MsgCreateAccount.fromJson(Map<String, dynamic> json) {
    return _$MsgCreateAccountFromJson(json);
  }

  @override
  Map<String, dynamic> asJson() {
    return _$MsgCreateAccountToJson(this);
  }

  @override
  List<Object> get props {
    return [
      moniker,
      name,
      surname,
      bio,
      pictures,
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
