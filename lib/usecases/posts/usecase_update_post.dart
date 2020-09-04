import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/usecases/usecases.dart';

/// Allows to sync all the posts that have been created offline as well as
/// all the likes and unlikes that have been set to posts.
class UpdatePostUseCase {
  final PostsRepository _postsRepository;

  UpdatePostUseCase({
    @required PostsRepository postsRepository,
  })  : assert(postsRepository != null),
        _postsRepository = postsRepository;

  /// Updates post that has not been posted to the chain
  Future<void> update(Post post) async {
    var canUpdateStatus = <PostStatusValue>[
      PostStatusValue.STORED_LOCALLY,
      PostStatusValue.ERRORED
    ];

    if (canUpdateStatus.contains(post.status.value)) {
      return _postsRepository.savePost(post);
    }
  }
}
