import 'package:mooncake/entities/entities.dart';

/// Represents the source that stores local information about the users.
abstract class LocalUsersSource {
  Stream<List<String>> get blockedUsersStream;

  /// Blocks the given [user] locally.
  Future<void> blockUser(User user);

  /// Unblocks the given [user].
  Future<void> unblockUser(User user);

  /// Returns the list of all the blocked users.
  Future<List<String>> getBlockedUsers();
}
