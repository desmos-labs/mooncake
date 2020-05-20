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
  final String username;

  @JsonKey(name: "bio", nullable: true)
  final String bio;

  @JsonKey(name: "profile_pic", nullable: true)
  final String profilePicUrl;

  @JsonKey(name: "cover_pic", nullable: true)
  final String coverPicUrl;

  User({
    @required this.address,
    this.username,
    this.bio,
    this.profilePicUrl,
    this.coverPicUrl,
  })  : assert(address != null && address.trim().isNotEmpty),
        assert(username == null || username.trim().isNotEmpty),
        assert(bio == null || bio.trim().isNotEmpty),
        assert(profilePicUrl == null || profilePicUrl.trim().isNotEmpty),
        assert(coverPicUrl == null || coverPicUrl.trim().isNotEmpty);

  factory User.fromAddress(String address) {
    return User(address: address);
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return _$UserFromJson(json);
  }

  /// Returns `true` iff the username is not null and not empty.
  bool get hasUsername => username != null && username.isNotEmpty;

  /// Returns the name that should be used on the screen
  String get screenName => username ?? address;

  /// Returns `true` iff the user has an associated avatar.
  bool get hasAvatar =>
      profilePicUrl != null && profilePicUrl.trim().isNotEmpty;

  /// Returns `true` iff the user has an associated cover picture.
  bool get hasCover => coverPicUrl != null && coverPicUrl.trim().isNotEmpty;

  Map<String, dynamic> toJson() {
    return _$UserToJson(this);
  }

  @override
  List<Object> get props {
    return [address, username, bio, profilePicUrl, coverPicUrl];
  }

  @override
  String toString() {
    return 'User { '
        'address: $address, '
        'bio: $bio, '
        'username: $username, '
        'avatarUrl : $profilePicUrl '
        '}';
  }
}
