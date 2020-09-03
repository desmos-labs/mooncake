import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';

/// Represents the current state of the edit account screen.
class EditAccountState extends Equatable {
  final MooncakeAccount originalAccount;
  final MooncakeAccount account;
  final bool saving;

  final String savingError;
  final bool showErrorPopup;

  /// Tells whether the current state contains some custom data
  /// different from the already existing user profile, or not.
  bool get containsCustomData {
    return originalAccount.dtag != account.dtag ||
        originalAccount.moniker != account.moniker ||
        originalAccount.bio != account.bio ||
        originalAccount.coverPicUri != account.coverPicUri ||
        originalAccount.profilePicUri != account.profilePicUri;
  }

  /// Tells whether the user can edit or not it's DTag.
  /// This is only permitted when the original one is empty, which
  /// means he's creating the profile for the first time.
  bool get canEditDTag {
    return originalAccount.dtag?.trim()?.isNotEmpty != true;
  }

  /// Returns `true` if the input DTag is valid, `false` otherwise.
  bool get isDTagValid {
    final originalDTag = originalAccount.dtag?.trim() ?? '';
    final newDTag = account.dtag?.trim() ?? '';

    if (originalDTag.isNotEmpty && newDTag.isEmpty) {
      return true;
    }

    return RegExp(r'^[A-Za-z0-9_]+$').hasMatch(newDTag) &&
        newDTag.length >= 3 &&
        newDTag.length <= 20;
  }

  /// Returns `true` iff the moniker input by the user is valid,
  /// or `false` otherwise.
  bool get isMonikerValid {
    final originalMoniker = originalAccount.moniker?.trim() ?? '';
    final newMoniker = account.moniker?.trim() ?? '';

    if (originalMoniker.isNotEmpty && newMoniker.isEmpty) {
      return true;
    }

    return newMoniker.length >= 3 && newMoniker.length <= 20;
  }

  /// Tells whether the user can save the profile or not.
  bool get canSave {
    return containsCustomData && isDTagValid && isMonikerValid;
  }

  EditAccountState({
    @required this.originalAccount,
    @required this.account,
    @required this.saving,
    @required this.savingError,
    @required this.showErrorPopup,
  })  : assert(originalAccount != null),
        assert(account != null),
        assert(saving != null),
        assert(showErrorPopup != null);

  factory EditAccountState.initial(MooncakeAccount account) {
    return EditAccountState(
      originalAccount: account,
      account: account,
      saving: false,
      savingError: null,
      showErrorPopup: false,
    );
  }

  EditAccountState copyWith({
    MooncakeAccount account,
    bool saving,
    String savingError,
    bool showErrorPopup,
  }) {
    return EditAccountState(
      originalAccount: originalAccount,
      account: account ?? this.account,
      saving: saving ?? this.saving,
      savingError: savingError ?? this.savingError,
      showErrorPopup: showErrorPopup ?? this.showErrorPopup,
    );
  }

  EditAccountState updateAccount({
    CosmosAccount cosmosAccount,
    String dtag,
    String moniker,
    String bio,
    String profilePicUrl,
    String coverPicUrl,
  }) {
    return copyWith(
      account: account.copyWith(
        cosmosAccount: cosmosAccount,
        dtag: dtag,
        moniker: moniker,
        bio: bio,
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
      savingError,
      showErrorPopup,
    ];
  }

  @override
  String toString() {
    return 'EditAccountState {'
        'originalAccount: $originalAccount, '
        'account: $account, '
        'saving: $saving, '
        'savingError: $savingError,'
        'showErrorPopup: $showErrorPopup '
        '}';
  }
}
