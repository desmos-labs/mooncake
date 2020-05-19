import 'package:mooncake/entities/entities.dart';

/// Represents the repository that should be used when dealing with users.
abstract class UsersRepository {
  /// Returns a stream that emits the list of blocked users as soon
  /// as a new user is blocked or an existing user is unblocked.
  Stream<List<String>> blockedUsersStream;

  /// Returns the list of blocked users.
  Future<List<String>> getBlockedUsers();

  /// Allows to block the given [user].
  Future<void> blockUser(User user);

  /// Allows to unblock the given [user].
  Future<void> unblockUser(User user);
}
