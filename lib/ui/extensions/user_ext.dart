import 'package:mooncake/entities/entities.dart';

/// Contains a set of extension methods for the user class.
extension UserExt on User {
  /// Returns the name that should be used on the screen
  String get screenName {
    if (moniker != null) return moniker;

    if (name != null) return name;

    return address.substring(0, 10) +
        "..." +
        address.substring(address.length - 5, address.length);
  }
}
