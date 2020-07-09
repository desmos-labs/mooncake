// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    address: json['address'] as String,
    dtag: json['dtag'] as String,
    moniker: json['moniker'] as String,
    bio: json['bio'] as String,
    profilePicUri: json['profile_pic'] as String,
    coverPicUri: json['cover_pic'] as String,
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'address': instance.address,
      'dtag': instance.dtag,
      'moniker': instance.moniker,
      'bio': instance.bio,
      'profile_pic': instance.profilePicUri,
      'cover_pic': instance.coverPicUri,
    };
