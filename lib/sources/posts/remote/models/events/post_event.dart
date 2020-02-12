import 'package:meta/meta.dart';
import 'package:mooncake/sources/posts/export.dart';

/// Represents a generic post-related event.
class PostEvent extends ChainEvent {
  final String postId;

  PostEvent({
    @required String height,
    @required this.postId,
  })  : assert(postId != null),
        super(height: height);

  @override
  List<Object> get props => [height, postId];

  @override
  String toString() => 'PostEvent { postId: $postId }';
}
