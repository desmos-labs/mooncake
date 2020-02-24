import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';

/// Represents a generic posts list state.
abstract class PostsState extends Equatable {
  const PostsState();

  @override
  List<Object> get props => [];
}

/// Represents the state that should be used when the posts are being loaded
/// for the first time.
class PostsLoading extends PostsState {}

/// Represents the state that must be used when a list of posts should be made
/// visible to the user.
class PostsLoaded extends PostsState {
  /// User that is using the application.
  final User user;

  /// Lists of posts that should be shown to the user.
  final List<Post> posts;

  /// Tells whether the list is being refreshed.
  final bool refreshing;

  /// Tells if the app is syncing the user activities to the chain.
  final bool syncingPosts;

  PostsLoaded({
    @required this.user,
    @required this.posts,
    this.refreshing = false,
    this.syncingPosts = false,
  });

  PostsLoaded copyWith({
    int page,
    User user,
    List<Post> posts,
    bool refreshing,
    bool syncingPosts,
  }) {
    return PostsLoaded(
      user: user ?? this.user,
      posts: posts ?? this.posts,
      refreshing: refreshing ?? this.refreshing,
      syncingPosts: syncingPosts ?? this.syncingPosts,
    );
  }

  @override
  List<Object> get props => [
        posts,
        refreshing,
        syncingPosts,
      ];

  @override
  String toString() => 'PostsLoaded { '
      'posts: ${posts.length}, '
      'refreshing: $refreshing, '
      'syncingPosts: $syncingPosts, '
      '}';
}
