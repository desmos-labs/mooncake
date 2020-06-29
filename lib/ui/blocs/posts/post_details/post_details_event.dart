import 'package:equatable/equatable.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';

/// Represents a generic event related to the visualization of a post details.
abstract class PostDetailsEvent extends Equatable {
  const PostDetailsEvent();

  @override
  List<Object> get props => [];
}

/// Tells the Bloc to load the details of the post having the given id.
class LoadPostDetails extends PostDetailsEvent {
  final String postId;

  LoadPostDetails(this.postId);

  @override
  List<Object> get props => [postId];

  @override
  String toString() => 'LoadPost { postId: $postId }';
}

/// Tells the Bloc that the post details have been updated and should be shown
/// again inside the view.
class PostDetailsUpdated extends PostDetailsEvent {
  final Post post;

  PostDetailsUpdated(this.post);

  @override
  List<Object> get props => [post];
}

/// Tells the Bloc that the post comments should be updated.
class PostCommentsUpdated extends PostDetailsEvent {
  final List<Post> comments;

  PostCommentsUpdated(this.comments);

  @override
  List<Object> get props => [comments];
}

/// Tells the Bloc that it needs to visualize the selected tab.
class ShowTab extends PostDetailsEvent {
  final PostDetailsTab tab;

  ShowTab(this.tab);

  @override
  List<Object> get props => [tab];

  @override
  String toString() => 'ShowTab { tab: $tab }';
}
