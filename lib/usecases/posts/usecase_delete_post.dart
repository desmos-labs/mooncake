import 'package:meta/meta.dart';
import 'package:mooncake/usecases/usecases.dart';
import 'package:mooncake/entities/entities.dart';

/// Allows to delete a locally stored post.
class DeletePostUseCase {
  static const canDeleteStatus = <PostStatusValue>[
    PostStatusValue.STORED_LOCALLY,
    PostStatusValue.ERRORED
  ];

  final PostsRepository _postsRepository;

  DeletePostUseCase({
    @required PostsRepository postsRepository,
  })  : assert(postsRepository != null),
        _postsRepository = postsRepository;

  /// Deletes the locally stored post if it hasn't been posted.
  Future<void> delete(Post post) async {
    if (canDeleteStatus.contains(post.status.value)) {
      return _postsRepository.deletePost(post);
    }
  }
}
