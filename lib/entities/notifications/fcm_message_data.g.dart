// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fcm_message_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FcmMessageData _$FcmMessageDataFromJson(Map<String, dynamic> json) {
  return FcmMessageData(
    action: json['action'] as String,
    postId: json['post_id'] as String,
  );
}

Map<String, dynamic> _$FcmMessageDataToJson(FcmMessageData instance) =>
    <String, dynamic>{
      'action': instance.action,
      'post_id': instance.postId,
    };
