// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mooncake_account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MooncakeAccount _$MooncakeAccountFromJson(Map<String, dynamic> json) {
  return MooncakeAccount(
    cosmosAccount: json['cosmos_account'] == null
        ? null
        : CosmosAccount.fromJson(
            json['cosmos_account'] as Map<String, dynamic>),
    username: json['username'] as String,
    avatarUrl: json['avatar_url'] as String,
  );
}

Map<String, dynamic> _$MooncakeAccountToJson(MooncakeAccount instance) =>
    <String, dynamic>{
      'cosmos_account': instance.cosmosAccount?.toJson(),
      'avatar_url': instance.avatarUrl,
      'username': instance.username,
    };
