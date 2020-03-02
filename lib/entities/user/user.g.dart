// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    username: json['username'] as String,
    avatarUrl: json['avatar_url'] as String,
    accountData: json['account_data'] == null
        ? null
        : AccountData.fromJson(json['account_data'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'username': instance.username,
      'avatar_url': instance.avatarUrl,
      'account_data': instance.accountData?.toJson(),
    };
