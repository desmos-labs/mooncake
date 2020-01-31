// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_media.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostMedia _$PostMediaFromJson(Map<String, dynamic> json) {
  return PostMedia(
    url: json['uri'] as String,
    mimeType: json['mimetype'] as String,
  );
}

Map<String, dynamic> _$PostMediaToJson(PostMedia instance) => <String, dynamic>{
      'uri': instance.url,
      'mimetype': instance.mimeType,
    };
