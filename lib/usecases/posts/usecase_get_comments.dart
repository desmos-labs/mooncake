import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/usecases/usecases.dart';

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
  Stream<List<Post>> stream(String postId) {
    return _postsRepository.getPostCommentsStream(postId);
  }

  /// Returns a [Future] that emits the list of comments made to the
  /// post having the specified [postId].
  Future<List<Post>> local(String postId) {
    return _postsRepository.getPostComments(postId);
  }

  /// Returns the list of comments to the post having the given [postId].
  Future<List<Post>> fromRemote(String postId) {
    return _postsRepository.getPostComments(postId, refresh: true);
  }
}
