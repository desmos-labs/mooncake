import 'package:mooncake/entities/entities.dart';

/// Represents the repository that should be used when dealing with the
/// user wallet.
abstract class UserRepository {
  /// Saves the given mnemonic inside the secure storage of the device
  /// allowing it to be retrieved later.
  Future<Wallet> saveWallet(String mnemonic);

  /// Returns the mnemonic associated to the account having the given [address].
  /// If no mnemonic has been saved yet, returns `null`.
  Future<List<String>> getMnemonic(String address);

  /// Saves the given [account] as one of the many available accounts that
  /// can be used.
  /// If [syncRemote] is true, the account will also saved into the remote
  /// source as well.
  Future<AccountSaveResult> saveAccount(
    MooncakeAccount account, {
    bool syncRemote = false,
  });

  /// Sets the given [account] as the currently active one.
  /// The active account represents the main account that is being used
  /// by the user inside the whole application.
  Future<void> setActiveAccount(MooncakeAccount account);

  /// Returns the [MooncakeAccount] having the given [address].
  /// If no [MooncakeAccount] or [Wallet] have been saved using [saveWallet]
  /// and the account data cannot be retrieved, returns `null` instead.
  Future<MooncakeAccount> getAccount(String address);

  /// Returns the list of all the [MooncakeAccount]s that can be switched to
  /// by the application user.
  Future<List<MooncakeAccount>> getAccounts();

  /// Returns the [MooncakeAccount] representing the account that is marked
  /// as being currently active.
  /// If no account has been marked as such, `null` is returned instead.
  Future<MooncakeAccount> getActiveAccount();

  /// Refreshes the user account having the given [address] by downloading
  /// the data from the remote source.
  /// Returns the updated [MooncakeAccount] object.
  Future<MooncakeAccount> refreshAccount(String address);

  /// Returns a stream that emits the latest active [MooncakeAccount].
  Stream<MooncakeAccount> get activeAccountStream;

  /// Allows to sends funds from the faucet to the specified [user].
  Future<void> fundAccount(MooncakeAccount user);

  /// Saves the given [method] as the local user authentication method for
  /// the account having the given [address].
  Future<void> saveAuthenticationMethod(
    String address,
    AuthenticationMethod method,
  );

  /// Returns the local authentication method set for the account having
  /// the given [address].
  Future<AuthenticationMethod> getAuthenticationMethod(String address);

  /// Logouts the account having the given [address].
  /// After logging out the account, all its data will be deleted from the
  /// local storage.
  Future<void> logout(String address);

  /// Removes all the accounts data from the local storage.
  Future<void> deleteData();
}
