// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'msg_create_post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MsgCreatePost _$MsgCreatePostFromJson(Map<String, dynamic> json) {
  return MsgCreatePost(
    parentId: json['parent_id'] as String,
    message: json['message'] as String,
    allowsComments: json['allows_comments'] as bool,
    subspace: json['subspace'] as String,
    optionalData: (json['optional_data'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as String),
    ),
    creator: json['creator'] as String,
  );
}

Map<String, dynamic> _$MsgCreatePostToJson(MsgCreatePost instance) =>
    <String, dynamic>{
      'parent_id': instance.parentId,
      'message': instance.message,
      'allows_comments': instance.allowsComments,
      'subspace': instance.subspace,
      'optional_data': instance.optionalData,
      'creator': instance.creator,
    };
