import 'package:desmosdemo/entities/entities.dart';

/// Represents the repository that should be used when dealing with the
/// user wallet.
abstract class WalletRepository {
  /// Returns the [Wallet] instance of the current application user.
  Future<Wallet> getWallet();
}
