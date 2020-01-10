import 'package:dwitter/entities/entities.dart';
import 'package:dwitter/usecases/posts/posts.dart';
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
    return _postsRepository.getPostComments(postId);
  }
}
