import 'package:mooncake/entities/entities.dart';

/// Represents the repository that should be used when dealing with the
/// user wallet.
abstract class UserRepository {
  /// Saves the given mnemonic inside the secure storage of the device
  /// allowing it to be retrieved later.
  Future<Wallet> saveWallet(String mnemonic);

  /// Returns the mnemonic that is associated to the current application user.
  /// If no mnemonic has been saved yet, returns `null`.
  Future<List<String>> getMnemonic(String address);

  /// Saves the given [account] as the current user object.
  Future<AccountSaveResult> saveAccount(
    MooncakeAccount account, {
    bool syncRemote = false,
  });

  /// Returns the [AccountData] object containing the info of the current user.
  /// If no [MooncakeAccount] or [Wallet] have been saved using [saveWallet]
  /// and the account data cannot be retrieved, returns `null` instead.
  Future<MooncakeAccount> getAccount(String address);

  /// Returns the [AccountData] object containing the info of all locally stored users.
  /// If account data cannot be retrieved, returns an empty `List` instead.
  Future<List<MooncakeAccount>> getAccounts();

  /// Returns the [AccountData] object containing the info of the current user.
  /// If no [MooncakeAccount] or [Wallet] have been saved using [saveWallet]
  /// and the account data cannot be retrieved, returns `null` instead.
  Future<MooncakeAccount> getActiveAccount();

  /// Refreshes the user account downloading the data from the remote source.
  /// Returns the updated [MooncakeAccount] value.
  Future<MooncakeAccount> refreshAccount(String address);

  /// Returns a stream that emits all the user changes.
  Stream<MooncakeAccount> get accountStream;

  /// Allows to sends funds from the faucet to the specified [user].
  Future<void> fundAccount(MooncakeAccount user);

  /// Saves the given [method] as the local user authentication method.
  Future<void> saveAuthenticationMethod(AuthenticationMethod method);

  /// Returns the currently set authentication method.
  Future<AuthenticationMethod> getAuthenticationMethod();

  /// Deletes entirely the currently stored account data.
  Future<void> deleteData();
}
