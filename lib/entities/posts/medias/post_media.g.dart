// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_media.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostMedia _$PostMediaFromJson(Map<String, dynamic> json) {
  return PostMedia(
    uri: json['uri'] as String,
    mimeType: json['mime_type'] as String,
  );
}

Map<String, dynamic> _$PostMediaToJson(PostMedia instance) => <String, dynamic>{
      'uri': instance.uri,
      'mime_type': instance.mimeType,
    };
