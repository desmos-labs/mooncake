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

  /// Returns `true` iff the username is not null and not empty.
  bool get hasUsername => username != null && username.isNotEmpty;

  /// Returns the name that should be used on the screen
  String get screenName => username ?? address;

  @JsonKey(name: "avatar_url", nullable: true)
  final String avatarUrl;

  /// Returns `true` iff the user has an associated avatar.
  bool get hasAvatar => avatarUrl != null && avatarUrl.isNotEmpty;

  User({
    @required this.address,
    this.username,
    this.avatarUrl,
  }) : assert(address != null);

  factory User.fromAddress(String address) {
    return User(address: address);
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return _$UserFromJson(json);
  }

  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  List<Object> get props => [address, username, avatarUrl];

  // DONT COVER
  @override
  String toString() => 'User { '
      'address: $address, '
      'username: $username, '
      'avatarUrl : $avatarUrl '
      '}';
}
