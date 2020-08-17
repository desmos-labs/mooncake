import 'package:meta/meta.dart';
import 'package:mooncake/usecases/usecases.dart';
import 'package:mooncake/entities/entities.dart';

/// Allows to delete a locally stored post.
class DeletePostUseCase {
  final PostsRepository _postsRepository;

  DeletePostUseCase({
    @required PostsRepository postsRepository,
  })  : assert(postsRepository != null),
        _postsRepository = postsRepository;

  /// Deletes the locally stored post.
  Future<void> delete(Post post) {
    return _postsRepository.deletePost(post);
  }
}
