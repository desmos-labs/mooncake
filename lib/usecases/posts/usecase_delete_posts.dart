import 'package:meta/meta.dart';
import 'package:mooncake/usecases/usecases.dart';

/// Allows to delete the locally stored posts.
class DeletePostsUseCase {
  final PostsRepository _postsRepository;

  DeletePostsUseCase({
    @required PostsRepository postsRepository,
  })  : assert(postsRepository != null),
        _postsRepository = postsRepository;

  /// Deletes the locally stored posts.
  Future<void> delete() {
    return _postsRepository.deletePosts();
  }
}
