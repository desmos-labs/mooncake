import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/usecases/posts/posts.dart';

/// Allows to read all the posts.
class GetPostsUseCase {
  final PostsRepository _postsRepository;

  GetPostsUseCase({@required PostsRepository postsRepository})
      : assert(postsRepository != null),
        _postsRepository = postsRepository;

  /// Returns a [Stream] that emits new posts as they are created.
  Stream<List<Post>> stream() => _postsRepository.postsStream;
}
