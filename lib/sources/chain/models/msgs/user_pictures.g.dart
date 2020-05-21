// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_pictures.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserPictures _$UserPicturesFromJson(Map<String, dynamic> json) {
  return UserPictures(
    cover: json['cover'] as String,
    profile: json['profile'] as String,
  );
}

Map<String, dynamic> _$UserPicturesToJson(UserPictures instance) =>
    <String, dynamic>{
      'cover': instance.cover,
      'profile': instance.profile,
    };
