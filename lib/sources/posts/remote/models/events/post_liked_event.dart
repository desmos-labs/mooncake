import 'package:mooncake/sources/posts/export.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Represents an event that is emitted when a post is liked.
class PostLikedEvent extends ChainEvent implements Equatable {
  final String postId;
  final String liker;

  PostLikedEvent({
    @required this.postId,
    @required this.liker,
    @required String height,
  })  : assert(postId != null),
        assert(liker != null),
        super(height: height);

  @override
  List<Object> get props => [postId, liker];
}
