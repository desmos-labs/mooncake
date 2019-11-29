import 'package:meta/meta.dart';
import 'package:sacco/models/export.dart';

/// Represents the message that must be used when liking a post.
class MsgLikePost extends StdMsg {
  final String postId;
  final String liker;

  MsgLikePost({
    @required this.postId,
    @required this.liker,
  })  : assert(postId != null),
        super(
          type: "desmos/MsgLikePost",
          value: {
            "post_id": postId,
            "liker": liker,
          },
        );
}
