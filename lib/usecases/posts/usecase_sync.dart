import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/usecases/usecases.dart';

/// Allows to sync all the posts that have been created offline as well as
/// all the likes and unlikes that have been set to posts.
class SyncPostsUseCase {
  final UserRepository _userRepository;
  final PostsRepository _postsRepository;
  final SettingsRepository _settingsRepository;
  SyncPostsUseCase({
    @required UserRepository userRepository,
    @required PostsRepository postsRepository,
    @required SettingsRepository settingsRepository,
  })  : assert(userRepository != null),
        _userRepository = userRepository,
        assert(postsRepository != null),
        _postsRepository = postsRepository,
        assert(settingsRepository != null),
        _settingsRepository = settingsRepository;

  /// Syncs the locally stored data to the chain.
  Future<dynamic> sync() async {
    // Refresh the account
    final account = await _userRepository.refreshAccount();
    if (account.needsFunding) {
      print('im in need functings');
      // If the account needs the funds, ask for them and skip
      // the rest of the process
      return _userRepository.fundAccount(account);
    }

    // Sync the posts
    final response = await _postsRepository.syncPosts();
    print('AFTER SYNC');
    var successTxCount = 0;
    print('LENGTH');
    print(response.length);
    response.forEach((e) {
      if (e.status.value == PostStatusValue.TX_SENT) {
        successTxCount++;
      }
    });

    return successTxCount;
  }
}
