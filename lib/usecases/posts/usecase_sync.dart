import 'package:meta/meta.dart';
import 'package:mooncake/usecases/usecases.dart';

/// Allows to sync all the posts that have been created offline as well as
/// all the likes and unlikes that have been set to posts.
class SyncPostsUseCase {
  final UserRepository _userRepository;
  final PostsRepository _postsRepository;

  SyncPostsUseCase({
    @required UserRepository userRepository,
    @required PostsRepository postsRepository,
  })  : assert(userRepository != null),
        _userRepository = userRepository,
        assert(postsRepository != null),
        _postsRepository = postsRepository;

  /// Syncs the locally stored data to the chain.
  Future<void> sync() async {
    // Refresh the account
    final account = await _userRepository.refreshAccount();
    if (account.needsFunding) {
      // If the account needs the funds, ask for them and skip
      // the rest of the process
      return _userRepository.fundAccount(account);
    }

    // Sync the posts
    return _postsRepository.syncPosts();
  }
}
