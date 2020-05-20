import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';

part 'mooncake_account.g.dart';

/// Contains the data of the current application account
@immutable
@JsonSerializable(explicitToJson: true)
class MooncakeAccount extends User {
  /// Contains the current data of the Desmos account.
  @JsonKey(name: "cosmos_account")
  final CosmosAccount cosmosAccount;

  MooncakeAccount({
    @required this.cosmosAccount,
    String username,
    String bio,
    String profilePicUrl,
    String coverPicUrl,
  }) : super(
          address: cosmosAccount.address,
          username: username,
          bio: bio,
          profilePicUrl: profilePicUrl,
          coverPicUrl: coverPicUrl,
        );

  /// Creates a local account.
  factory MooncakeAccount.local(String address) {
    return MooncakeAccount(
      cosmosAccount: CosmosAccount.offline(address),
    );
  }

  /// Creates a [MooncakeAccount] from the given JSON map.
  factory MooncakeAccount.fromJson(Map<String, dynamic> json) {
    return _$MooncakeAccountFromJson(json);
  }

  /// Returns `true` iff the account needs to be funded.
  bool get needsFunding => cosmosAccount.coins.isEmpty;

  /// Creates a new [MooncakeAccount] object containing the same data
  /// as the original, but with the specified data replaced instead.
  MooncakeAccount copyWith({
    CosmosAccount cosmosAccount,
    String username,
    String bio,
    String profilePicUrl,
    String coverPicUrl,
  }) {
    return MooncakeAccount(
      cosmosAccount: cosmosAccount,
      username: username,
      bio: bio,
      profilePicUrl: profilePicUrl,
      coverPicUrl: coverPicUrl,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return _$MooncakeAccountToJson(this);
  }

  @override
  List<Object> get props {
    return super.props + [cosmosAccount];
  }

  @override
  String toString() {
    return 'MooncakeAccount {'
        'cosmosAccount: $cosmosAccount, '
        'username: $username, '
        'profilePicUrl: $profilePicUrl, '
        'coverPicUrl: $coverPicUrl '
        '}';
  }
}
