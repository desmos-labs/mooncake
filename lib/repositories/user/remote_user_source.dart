import 'package:mooncake/entities/entities.dart';

/// Represents the remote source that needs to be used when wanting to
/// deal with account data.
abstract class RemoteUserSource {
  /// Returns the account data of the user having the given [address].
  Future<AccountData> getAccountData(String address);
}
