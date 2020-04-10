import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/usecases/usecases.dart';

/// Allows to get a stream emitting the details of a post based on
/// its id, each time that it is updated.
class GetPostDetailsUseCase {
  final PostsRepository _postsRepository;

  GetPostDetailsUseCase({
    @required PostsRepository postsRepository,
  })  : assert(postsRepository != null),
        _postsRepository = postsRepository;

  /// Returns the [Stream] emitting the details of the [Post] having the
  /// specified [postId] each time it is updated.
  Stream<Post> stream(String postId) {
    return _postsRepository.getPostByIdStream(postId);
  }

  /// Returns a [Future] that emits the currently locally stored post that
  /// has the given [postId].
  Future<Post> local(String postId) {
    return _postsRepository.getPostById(postId);
  }

  /// Returns a [Future] that emits the updated post retrieved from the remote
  /// server and stored locally.
  Future<Post> fromRemote(String postId) {
    return _postsRepository.getPostById(postId, refresh: true);
  }
}
