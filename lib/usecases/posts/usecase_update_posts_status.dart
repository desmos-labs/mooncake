import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/usecases/usecases.dart';

/// Allows to update the status of a list of posts based on the hash
/// of the transaction inside which they have been included.
class UpdatePostsStatusUseCase {
  final PostsRepository _postsRepository;

  UpdatePostsStatusUseCase({
    @required PostsRepository postsRepository,
  })  : assert(postsRepository != null),
        _postsRepository = postsRepository;

  /// Updates all the posts that have been included inside the transaction
  /// having the given [txHash] by setting the specified [status].
  Future<void> update(String txHash, PostStatus status) async {
    final posts = await _postsRepository.getPostsByTxHash(txHash);
    return _postsRepository.savePosts(posts.map((post) {
      return post.copyWith(status: status);
    }).toList());
  }
}
