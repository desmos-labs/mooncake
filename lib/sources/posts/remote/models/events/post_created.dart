import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/sources/sources.dart';

/// Represents the event that is emitted from the chain when a new post
/// is created.
class PostCreatedEvent extends PostEvent implements Equatable {
  final String parentId;
  final String owner;

  PostCreatedEvent({
    @required String postId,
    @required this.parentId,
    @required this.owner,
    @required String height,
  })  : assert(postId != null),
        assert(parentId != null),
        assert(owner != null),
        super(height: height, postId: postId);

  @override
  List get props => [postId, parentId, owner, height];
}
