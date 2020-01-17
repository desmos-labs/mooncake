// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_response.dart';

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
    subspace: json['subspace'] as String,
    creator: json['creator'] as String,
    reactions: (json['reactions'] as List)
        ?.map((e) =>
            e == null ? null : Reaction.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    commentsIds: (json['children'] as List)?.map((e) => e as String)?.toList(),
    optionalData: (json['optional_data'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as String),
    ),
  );
}

Map<String, dynamic> _$PostJsonToJson(PostJson instance) => <String, dynamic>{
      'id': instance.id,
      'parent_id': instance.parentId,
      'message': instance.message,
      'created': instance.created,
      'last_edited': instance.lastEdited,
      'allows_comments': instance.allowsComments,
      'subspace': instance.subspace,
      'creator': instance.creator,
      'reactions': instance.reactions?.map((e) => e?.toJson())?.toList(),
      'children': instance.commentsIds,
      'optional_data': instance.optionalData,
    };
