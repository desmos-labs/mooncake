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
    return _savePostAndParent(post, emit: true);
  }

  /// Saves the given [post], updating its parent as well (if it has one).
  /// If [emit] is true, after the update emits the new list of posts
  /// using the proper streams.
  Future<void> _savePostAndParent(Post post, {bool emit = false}) async {
    // Update the parent
    if (post.hasParent) {
      final parent = await _postsRepository.getPostById(post.parentId);
      final comments = parent.commentsIds;
      if (!comments.contains(post.id)) {
        comments.add(post.id);
      }
      await _savePostAndParent(post, emit: false);
    }

    // Save the post
    await _postsRepository.savePost(post, emit: emit);
  }
}
