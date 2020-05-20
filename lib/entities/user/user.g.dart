// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    address: json['address'] as String,
    username: json['moniker'] as String,
    bio: json['bio'] as String,
    profilePicUrl: json['profile_pic'] as String,
    coverPicUrl: json['cover_pic'] as String,
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'address': instance.address,
      'moniker': instance.username,
      'bio': instance.bio,
      'profile_pic': instance.profilePicUrl,
      'cover_pic': instance.coverPicUrl,
    };
