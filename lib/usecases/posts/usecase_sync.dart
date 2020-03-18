import 'package:meta/meta.dart';
import 'package:mooncake/usecases/posts/posts.dart';
import 'package:mooncake/usecases/usecases.dart';

/// Allows to sync all the posts that have been created offline as well as
/// all the likes and unlikes that have been set to posts.
class SyncPostsUseCase {
  final UserRepository _userRepository;
  final PostsRepository _postsRepository;

  SyncPostsUseCase({
    @required PostsRepository postsRepository,
    @required UserRepository userRepository,
  })  : assert(postsRepository != null),
        _postsRepository = postsRepository,
        _userRepository = userRepository;

  /// Syncs the locally stored data to the chain.
  Future<void> sync() async {
    await _userRepository.refreshAccount();
    await _postsRepository.syncPosts();
  }
}
