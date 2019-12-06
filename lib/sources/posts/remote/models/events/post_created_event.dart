import 'package:desmosdemo/sources/sources.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Represents the event that is emitted from the chain when a new post
/// is created.
class PostCreatedEvent extends Equatable implements ChainEvent {
  final String postId;
  final String parentId;
  final String owner;

  PostCreatedEvent({
    @required this.postId,
    @required this.parentId,
    @required this.owner,
  })  : assert(postId != null),
        assert(parentId != null),
        assert(owner != null);

  @override
  List get props => [postId, parentId, owner];
}
