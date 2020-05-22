import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'user.g.dart';

/// Contains the data of a generic user.
@immutable
@JsonSerializable(explicitToJson: true)
class User extends Equatable {
  /// Represents the Desmos address of the user
  @JsonKey(name: "address", nullable: false)
  final String address;

  /// Represents the username of the user.
  /// Do not use this directly, use [screenName] instead.
  @JsonKey(name: "moniker", nullable: true)
  final String moniker;

  @JsonKey(name: "name", nullable: true)
  final String name;

  @JsonKey(name: "surname", nullable: true)
  final String surname;

  @JsonKey(name: "bio", nullable: true)
  final String bio;

  @JsonKey(name: "profile_pic")
  final String profilePicUri;

  @JsonKey(name: "cover_pic", nullable: true)
  final String coverPicUri;

  User({
    @required this.address,
    this.moniker,
    this.name,
    this.surname,
    this.bio,
    this.profilePicUri,
    this.coverPicUri,
  })  : assert(address != null && address.trim().isNotEmpty),
        assert(moniker == null || moniker.trim().isNotEmpty),
        assert(name == null || moniker.trim().isNotEmpty),
        assert(surname == null || moniker.trim().isNotEmpty),
        assert(bio == null || bio.trim().isNotEmpty),
        assert(profilePicUri == null || profilePicUri.trim().isNotEmpty),
        assert(coverPicUri == null || coverPicUri.trim().isNotEmpty);

  factory User.fromAddress(String address) {
    return User(address: address);
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return _$UserFromJson(json);
  }

  /// Returns `true` iff the user has an associated avatar.
  bool get hasAvatar {
    return profilePicUri != null && profilePicUri.trim().isNotEmpty;
  }

  /// Returns `true` iff the user has an associated cover picture.
  bool get hasCover {
    return coverPicUri != null && coverPicUri.trim().isNotEmpty;
  }

  Map<String, dynamic> toJson() {
    return _$UserToJson(this);
  }

  @override
  List<Object> get props {
    return [
      address,
      moniker,
      name,
      surname,
      bio,
      profilePicUri,
      coverPicUri,
    ];
  }

  @override
  String toString() {
    return 'User { '
        'address: $address, '
        'bio: $bio, '
        'username: $moniker, '
        'name: $name, '
        'surname: $surname, '
        'profilePic : $profilePicUri,'
        'coverPic: $coverPicUri '
        '}';
  }
}
