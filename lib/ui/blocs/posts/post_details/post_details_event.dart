import 'package:equatable/equatable.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';

/// Represents a generic event related to the visualization of a post details.
abstract class PostDetailsEvent extends Equatable {
  const PostDetailsEvent();

  @override
  List<Object> get props => [];
}

/// Tells the Bloc that the details of a post have been loaded and it
/// is ready to be shown to the user.
class ShowPostDetails extends PostDetailsEvent {
  final Post post;
  final List<Post> comments;

  ShowPostDetails({this.post, this.comments});

  @override
  List<Object> get props => [post, comments];

  @override
  String toString() => 'ShowPostDetails { post: $post, comments: $comments }';
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

/// Toggles the like to the post, either adding or removing it.
class ToggleLike extends PostDetailsEvent {
  @override
  String toString() => 'ToggleLike';
}

/// Toggle the emoji to the post, either adding or removing it.
class ToggleReaction extends PostDetailsEvent {
  final String reaction;

  ToggleReaction(this.reaction);

  @override
  List<Object> get props => [reaction];

  @override
  String toString() => 'ToggleEmoji { reaction: $reaction }';
}
