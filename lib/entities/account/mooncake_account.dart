import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';

part 'mooncake_account.g.dart';

/// Contains the data of the current application account
@immutable
@JsonSerializable(explicitToJson: true)
class MooncakeAccount extends User {
  /// Contains the current data of the Desmos account.
  @JsonKey(name: 'cosmos_account')
  final CosmosAccount cosmosAccount;

  MooncakeAccount({
    @required this.cosmosAccount,
    String dtag,
    String moniker,
    String bio,
    String profilePicUri,
    String coverPicUri,
  }) : super(
          address: cosmosAccount.address,
          dtag: dtag,
          moniker: moniker,
          bio: bio,
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
      dtag: user.dtag,
      moniker: user.moniker,
      bio: user.bio,
      profilePicUri: user.profilePicUri,
      coverPicUri: user.coverPicUri,
    );
  }

  /// Returns `true` iff the account needs to be funded.
  /// An account is defined to been in need for funding if the
  /// number of tokens are less than 1 token.
  bool get needsFunding {
    final feeTokens = cosmosAccount.coins.firstWhere(
      (element) => element.denom == Constants.FEE_TOKEN,
      orElse: () => null,
    );
    return feeTokens == null || int.parse(feeTokens.amount) < 1;
  }

  /// Creates a new [MooncakeAccount] object containing the same data
  /// as the original, but with the specified data replaced instead.
  MooncakeAccount copyWith({
    CosmosAccount cosmosAccount,
    String dtag,
    String moniker,
    String bio,
    String profilePicUri,
    String coverPicUrl,
  }) {
    return MooncakeAccount(
      cosmosAccount: cosmosAccount ?? this.cosmosAccount,
      dtag: dtag ?? this.dtag,
      moniker: moniker ?? this.moniker,
      bio: bio,
      profilePicUri: profilePicUri ?? this.profilePicUri,
      coverPicUri: coverPicUrl ?? coverPicUri,
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
        'bio: $bio, '
        'cosmosAccount: $cosmosAccount, '
        '}';
  }
}
