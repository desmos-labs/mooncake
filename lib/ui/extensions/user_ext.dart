import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/utils/utils.dart';

/// Contains a set of extension methods for the user class.
extension UserExt on User {
  /// Returns the name that should be used on the screen
  String get screenName {
    if (moniker != null && moniker.isNotEmpty) return moniker;

    if (name != null && name.isNotEmpty) return name;

    if (address == null) {
      Logger.log("User $this is invalid");
      return "<Invalid account>";
    }

    return address.substring(0, 10) +
        "..." +
        address.substring(address.length - 5, address.length);
  }
}
