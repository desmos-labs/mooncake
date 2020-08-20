import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';

/// Represents a generic state that is associated with the screen that
/// shows the details of a post.
abstract class PostDetailsState extends Equatable {
  const PostDetailsState();

  @override
  List<Object> get props => [];
}

/// Represents the state during which the post details are being loaded.
class LoadingPostDetails extends PostDetailsState {
  @override
  String toString() => 'LoadingPostDetails';
}

enum PostDetailsTab { COMMENTS, REACTIONS }

/// Represents the state that tells the post details have been loaded
/// properly and are ready to be shown.
class PostDetailsLoaded extends PostDetailsState {
  /// Tells if the details of the post are being refreshed or not.
  final bool refreshing;

  /// Represents the user that is using the application
  final MooncakeAccount user;

  /// Represents the details of the post currently loaded.
  /// This can be `null` if the post has not been loaded yet.
  final Post post;

  /// Represents the list of comments currently loaded.
  final List<Post> comments;

  /// Represents the currently selected tab inside the view.
  final PostDetailsTab selectedTab;

  /// Returns the number of comments associated to this post.
  int get commentsCount => comments.length;

  /// Returns the list of reactions associated to the post.
  List<Reaction> get reactions => post.reactions;

  /// Returns the number of reactions that the
  /// current post has.
  int get reactionsCount => reactions.length;

  /// Tells whether or not the post has been liked from the user.
  bool get isLiked => post.reactions
      .where((element) =>
          element.user.address == user.cosmosAccount.address &&
          element.value == Constants.LIKE_REACTION)
      .isNotEmpty;

  PostDetailsLoaded({
    @required this.refreshing,
    @required this.user,
    @required this.post,
    @required this.comments,
    @required this.selectedTab,
  });

  factory PostDetailsLoaded.first({
    @required MooncakeAccount user,
    @required Post post,
    @required List<Post> comments,
  }) {
    return PostDetailsLoaded(
      user: user,
      selectedTab: PostDetailsTab.COMMENTS,
      post: post,
      comments: comments ?? [],
      refreshing: false,
    );
  }

  PostDetailsLoaded copyWith({
    MooncakeAccount user,
    Post post,
    List<Post> comments,
    PostDetailsTab selectedTab,
    bool refreshing,
  }) {
    return PostDetailsLoaded(
      user: user ?? this.user,
      post: post ?? this.post,
      comments: comments?.isNotEmpty == true ? comments : this.comments,
      selectedTab: selectedTab ?? this.selectedTab,
      refreshing: refreshing ?? this.refreshing,
    );
  }

  @override
  List<Object> get props => [user, post, comments, selectedTab, refreshing];

  @override
  String toString() => 'PostDetailsLoaded { '
      'post: $post, '
      'comments: ${comments.length}, '
      'selectedTab: $selectedTab, '
      'refreshing: $refreshing '
      '}';
}
