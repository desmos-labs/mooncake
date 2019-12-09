// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_json.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostJson _$PostJsonFromJson(Map<String, dynamic> json) {
  return PostJson(
    id: json['id'] as String,
    parentId: json['parent_id'] as String,
    message: json['message'] as String,
    created: json['created'] as String,
    lastEdited: json['last_edited'] as String,
    allowsComments: json['allows_comments'] as bool,
    externalReference: json['external_reference'] as String,
    owner: json['owner'] as String,
    likes: (json['likes'] as List)
        ?.map((e) =>
            e == null ? null : LikeJson.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    commentsIds: (json['children'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$PostJsonToJson(PostJson instance) => <String, dynamic>{
      'id': instance.id,
      'parent_id': instance.parentId,
      'message': instance.message,
      'created': instance.created,
      'last_edited': instance.lastEdited,
      'allows_comments': instance.allowsComments,
      'external_reference': instance.externalReference,
      'owner': instance.owner,
      'likes': instance.likes?.map((e) => e?.toJson())?.toList(),
      'children': instance.commentsIds,
    };
