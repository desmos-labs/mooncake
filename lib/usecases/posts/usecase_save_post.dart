import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/usecases/usecases.dart';

/// Allows to save a new post into the repository.
class SavePostUseCase {
  final PostsRepository _postsRepository;

  SavePostUseCase({@required PostsRepository postsRepository})
      : assert(postsRepository != null),
        _postsRepository = postsRepository;

  /// Saves the given [post] inside the repository.
  Future<void> save(Post post) async {
    // Save the post
    await _postsRepository.savePost(post);

    // Update the parent
    if (post.hasParent) {
      final parent = await _postsRepository.getPostById(post.parentId);
      final comments = parent.commentsIds;
      if (!comments.contains(post.id)) {
        comments.add(post.id);
        await _postsRepository.savePost(parent);
      }
    }
  }
}
