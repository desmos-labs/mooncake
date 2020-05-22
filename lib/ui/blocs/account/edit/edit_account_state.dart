import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:mooncake/entities/entities.dart';

/// Represents the current state of the edit account screen.
class EditAccountState extends Equatable {
  final MooncakeAccount originalAccount;
  final MooncakeAccount account;
  final bool saving;

  bool get containsCustomData {
    return originalAccount.coverPicUri != account.coverPicUri ||
        originalAccount.profilePicUri != account.profilePicUri ||
        originalAccount.moniker != account.moniker ||
        originalAccount.name != account.name ||
        originalAccount.surname != account.surname ||
        originalAccount.bio != account.bio;
  }

  bool get isMonikerValid {
    final originalMoniker = originalAccount.moniker?.trim() ?? "";
    final newMoniker = account.moniker?.trim() ?? "";

    if (originalMoniker.isNotEmpty && newMoniker.isEmpty) {
      return true;
    }

    return newMoniker.length > 4 && newMoniker.length < 20;
  }

  bool get canSave {
    return containsCustomData && isMonikerValid;
  }

  EditAccountState({
    @required this.originalAccount,
    @required this.account,
    @required this.saving,
  });

  factory EditAccountState.initial(MooncakeAccount account) {
    return EditAccountState(
      originalAccount: account,
      account: account,
      saving: false,
    );
  }

  EditAccountState copyWith({
    MooncakeAccount account,
    bool saving,
  }) {
    return EditAccountState(
      originalAccount: originalAccount,
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
        profilePicUri: profilePicUrl,
        coverPicUrl: coverPicUrl,
      ),
    );
  }

  @override
  List<Object> get props {
    return [
      originalAccount,
      account,
      saving,
    ];
  }
}
