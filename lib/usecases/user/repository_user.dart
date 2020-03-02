import 'package:mooncake/entities/entities.dart';

/// Represents the repository that should be used when dealing with the
/// user wallet.
abstract class UserRepository {
  /// Saves the given mnemonic inside the secure storage of the device
  /// allowing it to be retrieved later.
  Future<void> saveWallet(String mnemonic);

  /// Returns the [Wallet] instance of the current application user.
  /// If no [Wallet] instance has been saved yet, returns null.
  Future<Wallet> getWallet();

  /// Returns the [AccountData] object containing the info of the current user.
  /// If no [User] or [Wallet] have been saved using [saveWallet] and the
  /// account data cannot be retrieved, returns `null` instead.
  Future<User> getUserData();

  /// Returns a stream that emits all the user changes.
  Stream<User> get userStream;

  /// Allows to sends funds from the faucet to the specified [user].
  Future<void> fundUser(User user);

  /// Deletes entirely the currently stored account data.
  Future<void> deleteData();
}
