// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'link_preview.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RichLinkPreview _$RichLinkPreviewFromJson(Map<String, dynamic> json) {
  return RichLinkPreview(
    title: json['title'] as String,
    description: json['description'] as String,
    image: json['image'] as String,
    appleIcon: json['appleIcon'] as String,
    favIcon: json['favIcon'] as String,
    url: json['url'] as String,
  );
}

Map<String, dynamic> _$RichLinkPreviewToJson(RichLinkPreview instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'image': instance.image,
      'appleIcon': instance.appleIcon,
      'favIcon': instance.favIcon,
      'url': instance.url,
    };
