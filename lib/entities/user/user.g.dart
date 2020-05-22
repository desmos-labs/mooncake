// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    address: json['address'] as String,
    username: json['moniker'] as String,
    avatarUrl: json['avatar_url'] as String,
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'address': instance.address,
      'moniker': instance.username,
      'avatar_url': instance.avatarUrl,
    };
