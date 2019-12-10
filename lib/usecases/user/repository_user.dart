import 'package:dwitter/entities/entities.dart';

/// Represents the repository that allows to perform common operations
/// related to the users profiles.
abstract class UserRepository {
  /// Returns the [User] containing the data of the user that
  /// is currently using the application.
  Future<User> getUser();
}
