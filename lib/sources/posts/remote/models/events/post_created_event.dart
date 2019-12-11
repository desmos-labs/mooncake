import 'package:dwitter/sources/sources.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Represents the event that is emitted from the chain when a new post
/// is created.
class PostCreatedEvent extends ChainEvent implements Equatable {
  final String postId;
  final String parentId;
  final String owner;

  PostCreatedEvent({
    @required this.postId,
    @required this.parentId,
    @required this.owner,
    @required String height,
  })  : assert(postId != null),
        assert(parentId != null),
        assert(owner != null),
        super(height: height);

  @override
  List get props => [postId, parentId, owner];
}
