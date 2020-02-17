import 'package:mooncake/entities/entities.dart';

/// Represents the repository that should be used when dealing with the
/// user wallet.
abstract class UserRepository {
  /// Saves the given mnemonic inside the secure storage of the device
  /// allowing it to be retrieved later.
  Future<void> saveWallet(String mnemonic);

  /// Returns the address associated to the user wallet.
  /// If no address has been set, returns `null` instead.
  Future<String> getAddress();

  /// Returns the [Wallet] instance of the current application user.
  /// If no [Wallet] instance has been saved yet, returns null.
  Future<Wallet> getWallet();

  /// Returns a stream that emits all the account changes.
  Stream<AccountData> observeAccount();

  /// Returns the [AccountData] object containing the info of the current user.
  /// If no wallet has been saved using [saveWallet] and the account data
  /// cannot be retrieved, returns `null` instead.
  Future<AccountData> getAccount();

  /// Allows to sends funds from the faucet to the specified [account].
  Future<void> fundAccount(AccountData account);

  /// Deletes entirely the currently stored account data.
  Future<void> deleteData();
}
