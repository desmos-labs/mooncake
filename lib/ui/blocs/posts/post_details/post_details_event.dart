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

/// Tells the Bloc to load the details of the post having the given id.
class LoadPostDetails extends PostDetailsEvent {
  final String postId;

  LoadPostDetails(this.postId);

  @override
  List<Object> get props => [postId];

  @override
  String toString() => 'LoadPost { postId: $postId }';
}

/// Tells the Bloc that the user has requested the post details to be
/// refreshed.
class RefreshPostDetails extends PostDetailsEvent {
  @override
  String toString() => 'RefreshPostDetails';
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
