import 'package:meta/meta.dart';
import 'package:sacco/models/export.dart';

/// Represents the message that must be used when add a reaction
/// to a post.
class MsgAddPostReaction extends StdMsg {
  final String postId;
  final String reaction;
  final String user;

  MsgAddPostReaction({
    @required this.postId,
    @required this.reaction,
    @required this.user,
  })  : assert(postId != null),
        assert(value != null),
        assert(user != null),
        super(
          type: "desmos/MsgAddPostReaction",
          value: {
            "post_id": postId,
            "value": reaction,
            "user": user,
          },
        );
}
