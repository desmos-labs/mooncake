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
    dtag: json['dtag'] as String,
    moniker: json['moniker'] as String,
    bio: json['bio'] as String,
    profilePicUri: json['profile_pic'] as String,
    coverPicUri: json['cover_pic'] as String,
  );
}

Map<String, dynamic> _$MooncakeAccountToJson(MooncakeAccount instance) =>
    <String, dynamic>{
      'dtag': instance.dtag,
      'moniker': instance.moniker,
      'bio': instance.bio,
      'profile_pic': instance.profilePicUri,
      'cover_pic': instance.coverPicUri,
      'cosmos_account': instance.cosmosAccount?.toJson(),
    };
