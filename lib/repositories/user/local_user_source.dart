import 'package:mooncake/entities/entities.dart';

/// Represents the source that should be used when wanting to get
/// the wallet of the current application user.
abstract class LocalUserSource {
  /// Saves the given mnemonic inside the secure storage of the device
  /// allowing it to be retrieved later.
  Future<void> saveWallet(String mnemonic);

  /// Returns the address associated with the current wallet.
  Future<String> getAddress();

  /// Returns the [Wallet] instance associated with the current
  /// application user.
  Future<Wallet> getWallet();

  /// Saves the given [data] as the current local user data.
  Future<void> saveData(AccountData data);

  /// Returns the currently stored [AccountData], or `null` if no data
  /// are currently stored.
  Future<AccountData> getAccountData();

  /// Completely wipes the currently stored wallet for the user.
  Future<void> deleteData();
}
