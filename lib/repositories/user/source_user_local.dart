import 'package:mooncake/entities/entities.dart';

/// Represents the source that should be used when wanting to get
/// the wallet of the current application user.
abstract class LocalUserSource {
  /// Saves the given mnemonic inside the secure storage of the device
  /// allowing it to be retrieved later.
  Future<void> saveWallet(String mnemonic);

  /// Returns the mnemonic that is associated to the current application user.
  /// If no mnemonic has been saved yet, returns `null`.
  Future<List<String>> getMnemonic();

  /// Returns the [Wallet] instance of the current application user.
  /// If no [Wallet] instance has been saved yet, returns `null`.
  Future<Wallet> getWallet();

  /// Saves the given [data] as the current local user data.
  Future<void> saveAccount(MooncakeAccount data);

  /// Returns the [User] containing the data of the current app user.
  /// If no [User] or [Wallet] have been saved yet, returns `null`.
  Future<MooncakeAccount> getAccount();

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
