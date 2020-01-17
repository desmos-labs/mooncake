import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/sources/sources.dart';

/// Allows to convert a [PostJson] instance into a [Post] object.
class PostJsonConverter {
  Post toPost(PostJson json) {
    return Post(
      id: json.id,
      parentId: json.parentId,
      message: json.message,
      created: json.created,
      lastEdited: json.lastEdited,
      allowsComments: json.allowsComments,
      subspace: json.subspace,
      optionalData: json.optionalData ?? {},
      owner: json.creator,
      reactions: json.reactions ?? [],
      commentsIds: json.commentsIds ?? [],
      status: PostStatus(value: PostStatusValue.SYNCED),
    );
  }
}
