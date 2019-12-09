import 'package:desmosdemo/entities/entities.dart';
import 'package:desmosdemo/usecases/posts/posts.dart';
import 'package:meta/meta.dart';

/// Allows to read all the posts.
class GetPostsUseCase {
  final PostsRepository _postsRepository;

  GetPostsUseCase({@required PostsRepository postsRepository})
      : assert(postsRepository != null),
        _postsRepository = postsRepository;

  /// Returns the currently stored posts as a list.
  Future<List<Post>> get() {
    return _postsRepository.getPosts();
  }

  /// Returns a [Stream] that emits new posts as they are created.
  Stream<Post> stream() {
    return _postsRepository.postsStream;
  }
}
