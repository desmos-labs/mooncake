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
    medias: (json['attachments'] as List)
        ?.map((e) =>
            e == null ? null : PostMedia.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    poll: json['poll_data'] == null
        ? null
        : ChainPollData.fromJson(json['poll_data'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$MsgCreatePostToJson(MsgCreatePost instance) {
  final val = <String, dynamic>{
    'parent_id': instance.parentId,
    'message': instance.message,
    'allows_comments': instance.allowsComments,
    'subspace': instance.subspace,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('optional_data', instance.optionalData);
  val['creator'] = instance.creator;
  writeNotNull(
      'attachments', instance.medias?.map((e) => e?.toJson())?.toList());
  writeNotNull('poll_data', instance.poll?.toJson());
  return val;
}
