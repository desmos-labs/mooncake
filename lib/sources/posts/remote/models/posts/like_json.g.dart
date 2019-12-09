// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'like_json.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LikeJson _$LikeJsonFromJson(Map<String, dynamic> json) {
  return LikeJson(
    owner: json['owner'] as String,
    created: json['created'] as String,
  );
}

Map<String, dynamic> _$LikeJsonToJson(LikeJson instance) => <String, dynamic>{
      'created': instance.created,
      'owner': instance.owner,
    };
