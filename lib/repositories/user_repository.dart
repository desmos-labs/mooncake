import 'package:desmosdemo/models/models.dart';

import '../models/models.dart';

/// Allows to easily perform user-related operations.
class UserRepository {
  /// Returns the instance representing the user that is currently
  /// logged in.
  Future<User> getUser() async {
    return User(
      address: "test-address",
      username: "riccardo.montagnin",
      avatarUrl:
          "https://cdn3.iconfinder.com/data/icons/business-avatar-1/512/7_avatar-512.png",
    );
  }
}
