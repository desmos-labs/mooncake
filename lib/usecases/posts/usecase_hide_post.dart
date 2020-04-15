import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/usecases/usecases.dart';

/// Allows to easily hide a post from the user view.
class HidePostUseCase {
  final PostsRepository _postsRepository;

  HidePostUseCase({
    @required PostsRepository postsRepository,
  })  : assert(postsRepository != null),
        _postsRepository = postsRepository;

  /// Hides the given [post] from the view of the user.
  Future<Post> hide(Post post) async {
    final hiddenPost = post.copyWith(hidden: true);
    await _postsRepository.savePost(hiddenPost);
    return hiddenPost;
  }
}
