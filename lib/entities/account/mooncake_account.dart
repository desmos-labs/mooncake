import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';

part 'mooncake_account.g.dart';

/// Contains the data of the current application account
@immutable
@JsonSerializable(explicitToJson: true)
class MooncakeAccount extends Equatable {
  /// Contains the current data of the Desmos account.
  @JsonKey(name: "cosmos_account")
  final CosmosAccount cosmosAccount;

  @JsonKey(name: "avatar_url", nullable: true)
  final String avatarUrl;

  /// Represents the username of the user.
  /// Do not use this directly, use [screenName] instead.
  @JsonKey(name: "username", nullable: true)
  final String username;

  /// Returns the name that should be used on the screen
  String get screenName => username ?? cosmosAccount.address;

  /// Returns `true` iff the account needs to be funded.
  bool get needsFunding => cosmosAccount.coins.isEmpty;

  MooncakeAccount({
    @required this.cosmosAccount,
    @required this.username,
    @required this.avatarUrl,
  }) : assert(cosmosAccount != null);

  factory MooncakeAccount.local(String address) {
    return MooncakeAccount(
      cosmosAccount: CosmosAccount(
        address: address,
        sequence: 0,
        accountNumber: 0,
        coins: [],
      ),
      username: null,
      avatarUrl: null,
    );
  }

  factory MooncakeAccount.fromJson(Map<String, dynamic> json) {
    return _$MooncakeAccountFromJson(json);
  }

  Map<String, dynamic> toJson() => _$MooncakeAccountToJson(this);

  @override
  List<Object> get props => [cosmosAccount, avatarUrl, username];

  @override
  String toString() => 'MooncakeAccount {'
      'cosmosAccount: $cosmosAccount, '
      'avatarUrl: $avatarUrl, '
      'username: $username '
      '}';
}
