import 'package:mooncake/entities/entities.dart';

/// Represents the source that should be used when wanting to get
/// the wallet of the current application user.
abstract class LocalUserSource {
  /// Saves the given mnemonic inside the secure storage of the device
  /// allowing it to be retrieved later.
  Future<Wallet> saveWallet(String mnemonic);

  /// Returns the mnemonic that is associated to the given address
  /// If no mnemonic has been saved yet, returns `null`.
  Future<List<String>> getMnemonic(String address);

  /// Returns the [Wallet] instance of the given address.
  /// If no [Wallet] instance has been saved yet, returns `null`.
  Future<Wallet> getWallet(String address);

  /// Saves the given [data] as the current local user data.
  Future<MooncakeAccount> saveAccount(MooncakeAccount data);

  /// Returns the [User] containing the data of the of the given address.
  /// If no [User] or [Wallet] have been saved yet, returns `null`.
  Future<MooncakeAccount> getAccount(String address);

  /// Returns a `List` of Users localled stored on the device.
  Future<List<MooncakeAccount>> getAccounts();

  /// Returns the [User] that is currently selected.
  /// If no [User] it will return `null`.
  Future<MooncakeAccount> getActiveAccount();

  /// Returns the [User] that is currently selected.
  /// If no [User] it will return `null`.
  Future<void> setActiveAccount(MooncakeAccount account);

  /// Returns the [Stream] that emits all the new [User]
  /// once they have been saved.
  Stream<MooncakeAccount> get accountStream;

  /// Saves the given [method] as the local user authentication method.
  Future<void> saveAuthenticationMethod(AuthenticationMethod method);

  /// Returns the currently set authentication method.
  /// If no method has been set yet, returns `null` instead.
  Future<AuthenticationMethod> getAuthenticationMethod();

  /// Completely wipes the currently stored wallet for the user.
  Future<void> wipeData();
}
