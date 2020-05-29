import 'package:meta/meta.dart';
import 'package:mooncake/entities/user/user.dart';
import 'package:mooncake/usecases/usecases.dart';

import 'source_users_local.dart';

/// Implementation of [UsersRepository].
class UsersRepositoryImpl extends UsersRepository {
  final LocalUsersSource _localUsersSource;

  UsersRepositoryImpl({
    @required LocalUsersSource localUsersSource,
  })  : assert(localUsersSource != null),
        _localUsersSource = localUsersSource;

  @override
  Stream<List<String>> get blockedUsersStream {
    return _localUsersSource.blockedUsersStream;
  }

  @override
  Future<List<String>> getBlockedUsers() {
    return _localUsersSource.getBlockedUsers();
  }

  @override
  Future<void> blockUser(User user) {
    return _localUsersSource.blockUser(user);
  }

  @override
  Future<void> unblockUser(User user) {
    return _localUsersSource.unblockUser(user);
  }
}
