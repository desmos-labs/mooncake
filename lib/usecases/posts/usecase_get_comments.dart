import 'package:desmosdemo/entities/entities.dart';
import 'package:desmosdemo/usecases/posts/posts.dart';
import 'package:meta/meta.dart';

/// Allows to read the comments of a post having a specific id.
class GetCommentsUseCase {
  final PostsRepository _postsRepository;

  GetCommentsUseCase({@required PostsRepository postsRepository})
      : assert(postsRepository != null),
        _postsRepository = postsRepository;

  /// Returns the list of the comments associated with the post
  /// having the specified [postId].
  /// If no post with the given [postId] was found, an empty list is
  /// returned.
  Future<List<Post>> get(String postId) async {
    final post = await _postsRepository.getPostById(postId);

    if (post == null) {
      // The post does not exist, so no comments exist as well
      return [];
    }

    return Future.wait(post.commentsIds
        .map((id) => _postsRepository.getPostById(id))
        .toList());
  }
}
