import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/usecases/posts/posts.dart';
import 'package:mooncake/usecases/usecases.dart';
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
  Future<void> sync() async {
    // Get the posts
    final posts = await _postsRepository.getPostsToSync();
    final syncingStatus = PostStatus(value: PostStatusValue.SYNCING);
    final syncingPosts = posts
        .where((post) {
          // The post has a TO_BE_SYNCED status so it must be synced
          if (post.status.value == PostStatusValue.TO_BE_SYNCED ||
              post.status.value == PostStatusValue.ERRORED) {
            return true;
          }

          final creationData = DateTime.tryParse(post.created);

          // The post has a SYNCING status so we must check how long it
          // passed till its creation
          if (post.status.value == PostStatusValue.SYNCING) {
            // If more than two minutes have been passed, sync again the
            // post
            final syncTimeout = DateTime.now().subtract(Duration(minutes: 2));
            return creationData?.isBefore(syncTimeout) == true;
          }

          return false;
        })
        .map((post) => post.copyWith(status: syncingStatus))
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
    try {
      await _postsRepository.syncPosts(syncingPosts);
    } catch (error) {
      print("Sync error: $error");
      final status = PostStatus(
        value: PostStatusValue.ERRORED,
        error: error.toString(),
      );

      // Set the posts state to failed
      syncingPosts.forEach((post) async {
        await _postsRepository.savePost(post.copyWith(status: status));
      });
    }
  }
}
