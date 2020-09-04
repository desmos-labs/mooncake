import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'user.g.dart';

/// Contains the data of a generic user.
@immutable
@JsonSerializable(explicitToJson: true)
class User extends Equatable {
  /// Represents the Desmos address of the user
  @JsonKey(name: 'address', nullable: false)
  final String address;

  /// Represents the unique DTag of the user.
  @JsonKey(name: 'dtag', nullable: true)
  final String dtag;

  /// Represents the username of the user.
  @JsonKey(name: 'moniker', nullable: true)
  final String moniker;

  @JsonKey(name: 'bio', nullable: true)
  final String bio;

  @JsonKey(name: 'profile_pic')
  final String profilePicUri;

  @JsonKey(name: 'cover_pic', nullable: true)
  final String coverPicUri;

  const User({
    @required this.address,
    this.dtag,
    this.moniker,
    this.bio,
    this.profilePicUri,
    this.coverPicUri,
  }) : assert(address != null);

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
      dtag,
      moniker,
      bio,
      profilePicUri,
      coverPicUri,
    ];
  }

  @override
  String toString() {
    return 'User {'
        'address: $address, '
        'dtag: $dtag, '
        'moniker: $moniker, '
        'bio: $bio, '
        'profilePicUri: $profilePicUri, '
        'coverPicUri: $coverPicUri '
        '}';
  }
}
