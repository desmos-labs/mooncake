import 'package:mooncake/entities/entities.dart';

/// Represents the source that should be used when wanting to get
/// the wallet of the current application user.
abstract class LocalUserSource {
  /// Saves the given mnemonic inside the secure storage of the device
  /// allowing it to be retrieved later.
  Future<void> saveWallet(String mnemonic);

  /// Returns the [Wallet] instance associated with the current
  /// application user.
  Future<Wallet> getWallet();

  /// Returns the [User] containing the data of the current app user.
  /// If no [User] or [Wallet] have been saved yet, returns `null`.
  Future<User> getUser();

  /// Returns the [Stream] that emits all the new [User]
  /// once they have been saved.
  Stream<User> get userStream;

  /// Saves the given [data] as the current local user data.
  Future<void> saveUser(User data);

  /// Completely wipes the currently stored wallet for the user.
  Future<void> wipeData();
}
