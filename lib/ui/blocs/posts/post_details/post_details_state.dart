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
  /// Represents the details of the post currently loaded.
  /// This can be `null` if the post has not been loaded yet.
  final Post post;

  /// Represents the list of comments currently loaded.
  final List<Post> comments;

  /// Represents the currently selected tab inside the view.
  final PostDetailsTab selectedTab;

  PostDetailsLoaded({
    @required this.post,
    @required this.comments,
    @required this.selectedTab,
  });

  factory PostDetailsLoaded.first({
    @required Post post,
    @required List<Post> comments,
  }) {
    return PostDetailsLoaded(
      selectedTab: PostDetailsTab.COMMENTS,
      post: post,
      comments: comments ?? [],
    );
  }

  PostDetailsLoaded copyWith({
    Post post,
    List<Post> comments,
    PostDetailsTab selectedTab,
  }) {
    return PostDetailsLoaded(
      post: post ?? this.post,
      comments: comments?.isNotEmpty == true ? comments : this.comments,
      selectedTab: selectedTab ?? this.selectedTab,
    );
  }

  @override
  List<Object> get props => [post, comments, selectedTab];

  @override
  String toString() => 'PostDetailsLoaded { '
      'post: $post, '
      'comments: ${comments.length}, '
      'selectedTab: $selectedTab'
      '}';
}
