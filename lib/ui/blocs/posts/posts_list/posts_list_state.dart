import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';

/// Represents a generic posts list state.
abstract class PostsListState extends Equatable {
  const PostsListState();

  @override
  List<Object> get props => [];
}

/// Represents the state that should be used when the posts are being loaded
/// for the first time.
class PostsLoading extends PostsListState {}

/// Represents the state that must be used when a list of posts should be made
/// visible to the user.
class PostsLoaded extends PostsListState {
  /// User that is using the application.
  final MooncakeAccount user;

  /// Lists of posts that should be shown to the user.
  final List<Post> posts;

  /// Tells if a refresh should be done or not.
  final bool shouldRefresh;

  /// Tells whether the list is being refreshed.
  final bool refreshing;

  /// Tells if the app is syncing the user activities to the chain.
  final bool syncingPosts;

  PostsLoaded({
    @required this.user,
    @required this.posts,
    @required this.shouldRefresh,
    @required this.refreshing,
    @required this.syncingPosts,
  });

  factory PostsLoaded.first({MooncakeAccount user, List<Post> posts}) {
    return PostsLoaded(
      user: user,
      posts: posts ?? [],
      shouldRefresh: false,
      refreshing: false,
      syncingPosts: false,
    );
  }

  PostsLoaded copyWith({
    MooncakeAccount user,
    List<Post> posts,
    bool shouldRefresh,
    bool refreshing,
    bool syncingPosts,
  }) {
    return PostsLoaded(
      user: user ?? this.user,
      posts: posts ?? this.posts,
      shouldRefresh: shouldRefresh ?? this.shouldRefresh,
      refreshing: refreshing ?? this.refreshing,
      syncingPosts: syncingPosts ?? this.syncingPosts,
    );
  }

  @override
  List<Object> get props => [
        user,
        posts,
        shouldRefresh,
        refreshing,
        syncingPosts,
      ];

  @override
  String toString() => 'PostsLoaded { '
      'posts: ${posts.length}, '
      'shouldRefresh: $shouldRefresh, '
      'refreshing: $refreshing, '
      'syncingPosts: $syncingPosts, '
      '}';
}
