import 'package:desmosdemo/entities/entities.dart';
import 'package:desmosdemo/sources/posts/remote/models/models.dart';

import '../export.dart';
import 'export.dart';

class PostConverter {
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

  MsgCreatePost toMsgCreatePost(Post post) {
    return MsgCreatePost(
      parentId: post.parentId ?? "0",
      message: post.message,
      allowsComments: post.allowsComments ?? false,
      externalReference: post.externalReference ?? "",
      creator: post.owner,
    );
  }
}
