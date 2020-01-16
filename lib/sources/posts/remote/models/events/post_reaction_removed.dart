import 'package:mooncake/sources/sources.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Event that is emitted when a reaction is removed from a post.
class PostReactionRemovedEvent extends ChainEvent implements Equatable {
  final String postId;
  final String user;

  PostReactionRemovedEvent({
    @required this.postId,
    @required this.user,
    @required String height,
  })  : assert(postId != null),
        assert(user != null),
        super(height: height);

  @override
  List<Object> get props => [postId, user];
}
