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
    lastEdited: json['last_edited'] as String,
    allowsComments: json['allows_comments'] as bool,
    subspace: json['subspace'] as String,
    optionalData: (json['optional_data'] as Map<String, dynamic>)?.map(
          (k, e) => MapEntry(k, e as String),
        ) ??
        {},
    owner: json['creator'] == null
        ? null
        : User.fromJson(json['creator'] as Map<String, dynamic>),
    medias: (json['medias'] as List)
        ?.map((e) =>
            e == null ? null : PostMedia.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    reactions: (json['reactions'] as List)
        ?.map((e) =>
            e == null ? null : Reaction.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    commentsIds: (json['children'] as List)?.map((e) => e as String)?.toList(),
    status: Post._postStatusFromJson(json['status'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'id': instance.id,
      'parent_id': instance.parentId,
      'message': instance.message,
      'created': instance.created,
      'last_edited': instance.lastEdited,
      'allows_comments': instance.allowsComments,
      'subspace': instance.subspace,
      'creator': instance.owner?.toJson(),
      'optional_data': instance.optionalData,
      'medias': instance.medias?.map((e) => e?.toJson())?.toList(),
      'reactions': instance.reactions?.map((e) => e?.toJson())?.toList(),
      'children': instance.commentsIds,
      'status': instance.status?.toJson(),
    };
