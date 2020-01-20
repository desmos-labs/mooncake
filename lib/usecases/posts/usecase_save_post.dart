import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/usecases/posts/posts.dart';

/// Allows to save a new post into the repository.
class SavePostUseCase {
  final PostsRepository _postsRepository;

  SavePostUseCase({@required PostsRepository postsRepository})
      : assert(postsRepository != null),
        this._postsRepository = postsRepository;

  /// Saves the given [post] inside the repository.
  Future<void> save(Post post) {
    return _postsRepository.savePost(post);
  }
}
