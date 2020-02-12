import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/usecases/posts/posts.dart';
import 'package:meta/meta.dart';

/// Allows to read all the posts.
class GetPostsUseCase {
  final PostsRepository _postsRepository;

  GetPostsUseCase({@required PostsRepository postsRepository})
      : assert(postsRepository != null),
        _postsRepository = postsRepository;

  /// Returns the currently stored posts as a list.
  /// If [forceOnline] is true, downloads all the posts from the chain state
  /// and saves them offline.
  /// If an exception is thrown during the process, an empty list will be
  /// returned instead.
  Future<List<Post>> get({bool forceOnline = false}) {
    return _postsRepository.getPosts(forceOnline: forceOnline);
  }

  /// Returns a [Stream] that emits new posts as they are created.
  Stream<Post> stream() {
    return _postsRepository.postsStream;
  }
}
