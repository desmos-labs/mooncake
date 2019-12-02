import 'package:desmosdemo/entities/entities.dart';

/// Represents the source that should be used when wanting to get
/// the wallet of the current application user.
abstract class WalletSource {
  /// Returns the [Wallet] instance associated with the current
  /// application user.
  Future<Wallet> getWallet();
}
