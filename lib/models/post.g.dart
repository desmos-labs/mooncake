// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) {
  return Post(
    id: json['id'] as String,
    parentId: json['parent_id'] as String,
    message: json['message'] as String,
    created: json['created'] as String,
    lastEdited: json['lastEdited'] as String,
    allowsComments: json['allowsComments'] as bool,
    owner: json['owner'] == null
        ? null
        : User.fromJson(json['owner'] as Map<String, dynamic>),
    likes: (json['likes'] as List)
        ?.map(
            (e) => e == null ? null : Like.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    commentsIds:
        (json['comments_ids'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'id': instance.id,
      'parent_id': instance.parentId,
      'message': instance.message,
      'created': instance.created,
      'lastEdited': instance.lastEdited,
      'allowsComments': instance.allowsComments,
      'owner': instance.owner?.toJson(),
      'likes': instance.likes?.map((e) => e?.toJson())?.toList(),
      'comments_ids': instance.commentsIds,
    };
