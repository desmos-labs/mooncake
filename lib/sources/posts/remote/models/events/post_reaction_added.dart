import 'package:mooncake/sources/posts/export.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Represents an event that is emitted when a post is liked.
class PostReactionAdded extends ChainEvent implements Equatable {
  final String postId;
  final String user;

  PostReactionAdded({
    @required this.postId,
    @required this.user,
    @required String height,
  })  : assert(postId != null),
        assert(user != null),
        super(height: height);

  @override
  List<Object> get props => [postId, user];
}
