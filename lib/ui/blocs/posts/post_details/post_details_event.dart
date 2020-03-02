import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';

/// Represents a generic event related to the visualization of a post details.
abstract class PostDetailsEvent extends Equatable {
  const PostDetailsEvent();

  @override
  List<Object> get props => [];
}

/// Tells the BLoC to load the details of the post having the given [postId].
class LoadPostDetails extends PostDetailsEvent {
  final String postId;

  LoadPostDetails(this.postId);

  @override
  List<Object> get props => [postId];

  @override
  String toString() => 'LoadPostDetails { postId: $postId }';
}

/// Tells the BLoC that the details of a post have been loaded and it
/// is ready to be shown to the user.
class ShowPostDetails extends PostDetailsEvent {
  final Post post;
  final List<Post> comments;

  ShowPostDetails({@required this.post, @required this.comments});

  @override
  List<Object> get props => [post, comments];

  @override
  String toString() => 'ShowPostDetails { post: $post, comments: $comments }';
}

/// Tells the BLoC that it needs to visualize the selected tab.
class ShowTab extends PostDetailsEvent {
  final PostDetailsTab tab;

  ShowTab(this.tab);

  @override
  List<Object> get props => [tab];

  @override
  String toString() => 'ShowTab { tab: $tab }';
}
