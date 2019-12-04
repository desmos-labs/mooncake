import 'package:desmosdemo/entities/entities.dart';
import 'package:desmosdemo/usecases/posts/posts.dart';
import 'package:desmosdemo/usecases/usecases.dart';
import 'package:meta/meta.dart';

/// Allows to sync all the posts that have been created offline as well as
/// all the likes and unlikes that have been set to posts.
class SyncPostsUseCase {
  final PostsRepository _postsRepository;

  SyncPostsUseCase({
    @required PostsRepository postsRepository,
  })  : assert(postsRepository != null),
        _postsRepository = postsRepository;

  /// Syncs the locally stored data to the chain.
  /// Local data contains posts as well as likes and unlikes.
  Future<void> sync() async {
    // Get the posts
    final posts = await _postsRepository.getPosts();
    final syncingPosts = posts
        .where((post) {
          bool needsSync = post.status == PostStatus.TO_BE_SYNCED;

          // Sync all those posts that are stored as SYNCING
          // but have not yet been synced in the last 2 minutes
          if (post.status == PostStatus.SYNCING) {
            final creationData = DateTime.parse(post.created);
            final syncTimeout = DateTime.now().subtract(Duration(minutes: 2));
            needsSync = creationData.isBefore(syncTimeout);
          }

          return needsSync;
        })
        .map((post) => post.copyWith(status: PostStatus.SYNCING))
        .toList();

    if (syncingPosts.isEmpty) {
      // We do not have any post to be synced, so return.
      return;
    }

    // Set the posts as syncing
    syncingPosts.forEach((post) async {
      await _postsRepository.savePost(post);
    });

    // Send the post transactions
    await _postsRepository.syncPosts(syncingPosts);
  }
}
