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
    String moniker,
    String bio,
    String name,
    String surname,
    String profilePicUri,
    String coverPicUri,
  }) : super(
          address: cosmosAccount.address,
          moniker: moniker,
          bio: bio,
          name: name,
          surname: surname,
          profilePicUri: profilePicUri,
          coverPicUri: coverPicUri,
        );

  /// Creates a local account.
  factory MooncakeAccount.local(String address) {
    return MooncakeAccount(cosmosAccount: CosmosAccount.offline(address));
  }

  /// Creates a [MooncakeAccount] from the given JSON map.
  factory MooncakeAccount.fromJson(Map<String, dynamic> json) {
    return _$MooncakeAccountFromJson(json);
  }

  /// Creates a [MooncakeAccount] from the given [CosmosAccount] and [User].
  factory MooncakeAccount.fromUser(CosmosAccount account, User user) {
    return MooncakeAccount(
      cosmosAccount: account,
      moniker: user.moniker,
      bio: user.bio,
      name: user.name,
      surname: user.surname,
      profilePicUri: user.profilePicUri,
      coverPicUri: user.coverPicUri,
    );
  }

  /// Returns `true` iff the account needs to be funded.
  bool get needsFunding => cosmosAccount.coins.isEmpty;

  /// Creates a new [MooncakeAccount] object containing the same data
  /// as the original, but with the specified data replaced instead.
  MooncakeAccount copyWith({
    CosmosAccount cosmosAccount,
    String moniker,
    String bio,
    String name,
    String surname,
    String profilePicUri,
    String coverPicUrl,
  }) {
    return MooncakeAccount(
      cosmosAccount: cosmosAccount ?? this.cosmosAccount,
      moniker: moniker ?? this.moniker,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      bio: bio ?? this.bio,
      profilePicUri: profilePicUri ?? this.profilePicUri,
      coverPicUri: coverPicUrl ?? this.coverPicUri,
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
        'user: ${super.toString()} '
        '}';
  }
}
