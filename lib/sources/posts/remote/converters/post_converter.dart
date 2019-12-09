import 'package:desmosdemo/entities/entities.dart';
import 'package:desmosdemo/sources/posts/remote/models/models.dart';

import '../../export.dart';
import '../export.dart';

/// Allows to convert an on-chain post to a locally stored post.
/// Also converts a locally stored post to a [MsgCreatePost] instance.
class RemotePostConverter {
  /// Converts the given [PostJson] object into a [Post] instance.
  Post toPost(PostJson json) {
    return Post(
      id: json.id,
      parentId: json.parentId,
      message: json.message,
      created: json.created,
      lastEdited: json.lastEdited,
      allowsComments: json.allowsComments,
      externalReference: json.externalReference,
      owner: json.owner,
      likes: json.likes.map((l) => Like(owner: l.owner)).toList(),
      liked: false,
      commentsIds: json.commentsIds,
      status: PostStatus.SYNCED,
    );
  }
}
