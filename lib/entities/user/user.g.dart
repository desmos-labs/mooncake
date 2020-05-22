// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    address: json['address'] as String,
    moniker: json['moniker'] as String,
    name: json['name'] as String,
    surname: json['surname'] as String,
    bio: json['bio'] as String,
    profilePicUri: json['profile_pic'] as String,
    coverPicUri: json['cover_pic'] as String,
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'address': instance.address,
      'moniker': instance.moniker,
      'name': instance.name,
      'surname': instance.surname,
      'bio': instance.bio,
      'profile_pic': instance.profilePicUri,
      'cover_pic': instance.coverPicUri,
    };
