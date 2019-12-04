import 'package:desmosdemo/sources/sources.dart';
import 'package:meta/meta.dart';

class CreatePostEvent implements ChainEvent {
  final String postId;
  final String parentId;
  final String owner;

  CreatePostEvent({
    @required this.postId,
    @required this.parentId,
    @required this.owner,
  })  : assert(postId != null),
        assert(parentId != null),
        assert(owner != null);
}
