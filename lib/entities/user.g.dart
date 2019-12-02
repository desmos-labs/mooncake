// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    address: json['addres'] as String,
    username: json['username'] as String,
    avatarUrl: json['avatar_url'] as String,
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'addres': instance.address,
      'username': instance.username,
      'avatar_url': instance.avatarUrl,
    };
