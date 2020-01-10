import 'package:meta/meta.dart';
import 'package:sacco/models/export.dart';

/// Represents the message that must be used
/// when removing a reaction from a post.
class MsgRemovePostReaction extends StdMsg {
  final String postId;
  final String reaction;
  final String user;

  MsgRemovePostReaction({
    @required this.postId,
    @required this.reaction,
    @required this.user,
  })  : assert(postId != null),
        assert(reaction != null),
        assert(user != null),
        super(
          type: "desmos/MsgUnlikePost",
          value: {
            "post_id": postId,
            "reaction": reaction,
            "user": user,
          },
        );
}
