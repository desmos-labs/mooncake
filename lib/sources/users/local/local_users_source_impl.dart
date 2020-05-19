import 'package:meta/meta.dart';
import 'package:mooncake/entities/user/user.dart';
import 'package:mooncake/repositories/repositories.dart';
import 'package:sembast/sembast.dart';

/// Implements [LocalUsersSource] basing the storing on a local database.
class LocalUsersSourceImpl extends LocalUsersSource {
  static const BLOCKED_USERS_KEY = "blocked_users";

  final StoreRef _store = StoreRef.main();
  final Database _database;

  LocalUsersSourceImpl({@required Database database})
      : assert(database != null),
        _database = database;

  @override
  Stream<List<String>> get blockedUsersStream {
    final finder = Finder(filter: Filter.byKey(BLOCKED_USERS_KEY));
    return _store
        .query(finder: finder)
        .onSnapshots(_database)
        .map((event) {
      return ((event as List)?.map((e) => e as String)?.toList() ?? []);
    });
  }

  @visibleForTesting
  Future<void> saveUsers(List<String> users) async {
    return _store.record(BLOCKED_USERS_KEY).put(_database, users);
  }

  @override
  Future<List<String>> getBlockedUsers() async {
    final result = await _store.findFirst(
      _database,
      finder: Finder(filter: Filter.byKey(BLOCKED_USERS_KEY)),
    );
    return (result?.value as List)?.map((e) => e as String)?.toList() ?? [];
  }

  @override
  Future<void> blockUser(User user) async {
    final users = (await getBlockedUsers()).toSet();
    users.add(user.address);
    return saveUsers(users.toList());
  }

  @override
  Future<void> unblockUser(User user) async {
    final users = (await getBlockedUsers())
        .where((address) => address != user.address)
        .toList();
    return saveUsers(users);
  }
}
