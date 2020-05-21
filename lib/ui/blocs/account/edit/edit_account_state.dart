import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:mooncake/entities/entities.dart';

/// Represents the current state of the edit account screen.
class EditAccountState extends Equatable {
  final MooncakeAccount account;

  final bool saving;

  EditAccountState({
    @required this.account,
    @required this.saving,
  });

  factory EditAccountState.initial(MooncakeAccount account) {
    return EditAccountState(
      account: account,
      saving: false,
    );
  }

  EditAccountState copyWith({
    MooncakeAccount account,
    bool saving,
  }) {
    return EditAccountState(
      account: account ?? this.account,
      saving: saving ?? this.saving,
    );
  }

  EditAccountState updateAccount({
    CosmosAccount cosmosAccount,
    String moniker,
    String bio,
    String name,
    String surname,
    String profilePicUrl,
    String coverPicUrl,
  }) {
    return copyWith(
      account: account.copyWith(
        cosmosAccount: cosmosAccount,
        moniker: moniker,
        bio: bio,
        name: name,
        surname: surname,
        profilePicUrl: profilePicUrl,
        coverPicUrl: coverPicUrl,
      ),
    );
  }

  @override
  List<Object> get props {
    return [
      account,
      saving,
    ];
  }
}
