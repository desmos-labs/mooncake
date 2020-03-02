import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';

part 'user.g.dart';

/// Contains the data of a user.
@immutable
@JsonSerializable(explicitToJson: true)
class User extends Equatable {
  @JsonKey(name: "username", nullable: true)
  final String username;

  /// Returns `true` iff the username is not null and not empty.
  bool get hasUsername => username != null && username.isNotEmpty;

  @JsonKey(name: "avatar_url", nullable: true)
  final String avatarUrl;

  /// Returns `true` iff the user has an associated avatar.
  bool get hasAvatar => avatarUrl != null && avatarUrl.isNotEmpty;

  @JsonKey(name: "account_data")
  final AccountData accountData;

  /// Returns `true` iff the account needs to be funded.
  bool get needsFunding => accountData.coins.isEmpty;

  User({
    this.username,
    this.avatarUrl,
    @required this.accountData,
  }) : assert(accountData != null);

  factory User.fromAddress(String address) => User(
        accountData: AccountData(
          address: address,
          coins: [],
          accountNumber: 0,
          sequence: 0,
        ),
      );

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  List<Object> get props => [username, avatarUrl];

  // DONT COVER
  @override
  String toString() => 'User { '
      'username: $username, '
      'avatarUrl : $avatarUrl ,'
      'accountData: $accountData '
      '}';
}
