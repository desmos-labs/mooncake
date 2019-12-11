import 'package:meta/meta.dart';
import 'package:sacco/models/export.dart';

/// Represents the message that must be used when liking a post.
class MsgUnLikePost extends StdMsg {
  final String postId;
  final String liker;

  MsgUnLikePost({
    @required this.postId,
    @required this.liker,
  })  : assert(postId != null),
        super(
          type: "desmos/MsgUnlikePost",
          value: {
            "post_id": postId,
            "liker": liker,
          },
        );
}
