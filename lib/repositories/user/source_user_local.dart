import 'package:mooncake/entities/entities.dart';

/// Represents the source that should be used when wanting to get
/// the wallet of the current application user.
abstract class LocalUserSource {
  /// Saves the given mnemonic inside the secure storage of the device
  /// allowing it to be retrieved later.
  Future<Wallet> saveWallet(String mnemonic);

  /// Returns the mnemonic that is associated to the given [address]
  /// If no mnemonic has been saved yet, returns `null`.
  Future<List<String>> getMnemonic(String address);

  /// Returns the [Wallet] instance of the given [address].
  /// If no [Wallet] instance has been saved yet, returns `null`.
  Future<Wallet> getWallet(String address);

  /// Saves the given [data] inside the local device storage.
  Future<MooncakeAccount> saveAccount(MooncakeAccount data);

  /// Returns the [MooncakeAccount] associated to the given [address].
  /// If no [MooncakeAccount] for such [address] exists, returns `null` instead.
  Future<MooncakeAccount> getAccount(String address);

  /// Returns the list of all the locally stored [MooncakeAccount]s.
  Future<List<MooncakeAccount>> getAccounts();

  /// Returns the currently active [MooncakeAccount].
  /// If there is no active account, returns `null` instead.
  Future<MooncakeAccount> getActiveAccount();

  /// Sets the given [account] as the currently active one.
  Future<void> setActiveAccount(MooncakeAccount account);

  /// Returns the [Stream] that emits the latest active account that is
  /// selected by the user.
  Stream<MooncakeAccount> get activeAccountStream;

  /// Saves the given [method] as the authentication method for the
  /// account having the given [address].
  Future<void> saveAuthenticationMethod(
    String address,
    AuthenticationMethod method,
  );

  /// Returns the authentication method for the account having the given
  /// [address]. If not authentication method was set, returns `null` instead.
  Future<AuthenticationMethod> getAuthenticationMethod(String address);

  /// Performs the logout of the account having the given [address].
  /// After logging out, the acount and wallet information will be deleted
  /// from the local storage.
  Future<void> logout(String address);

  /// Wipes all the locally stored data about all the users and wallets.
  Future<void> wipeData();
}
