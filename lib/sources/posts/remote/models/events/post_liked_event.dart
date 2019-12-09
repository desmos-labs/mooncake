import 'package:desmosdemo/sources/posts/export.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Represents an event that is emitted when a post is liked.
class PostLikedEvent extends Equatable implements ChainEvent {
  final String postId;
  final String liker;

  PostLikedEvent({
    @required this.postId,
    @required this.liker,
  });

  @override
  List<Object> get props => [postId, liker];
}
