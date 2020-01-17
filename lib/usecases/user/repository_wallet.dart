import 'package:mooncake/entities/entities.dart';

/// Represents the repository that should be used when dealing with the
/// user wallet.
abstract class UserRepository {
  /// Saves the given mnemonic inside the secure storage of the device
  /// allowing it to be retrieved later.
  Future<void> saveWallet(String mnemonic);

  /// Returns the address associated to the user wallet.
  Future<String> getAddress();

  /// Returns the [Wallet] instance of the current application user.
  /// If no [Wallet] instance has been saved yet, returns null.
  Future<Wallet> getWallet();

  /// Returns the [AccountData] object containing the info of the current user.
  /// If no wallet has been saved using [saveWallet] and the account data
  /// cannot be retrieved, returns `null` instead.
  Future<AccountData> getAccount();

  /// Deletes entirely the currently stored account data.
  Future<void> deleteData();
}
