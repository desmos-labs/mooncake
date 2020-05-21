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
    moniker: json['moniker'] as String,
    bio: json['bio'] as String,
    name: json['name'] as String,
    surname: json['surname'] as String,
    profilePicUrl: json['profile_pic'] as String,
    coverPicUrl: json['cover_pic'] as String,
  );
}

Map<String, dynamic> _$MooncakeAccountToJson(MooncakeAccount instance) =>
    <String, dynamic>{
      'moniker': instance.moniker,
      'name': instance.name,
      'surname': instance.surname,
      'bio': instance.bio,
      'profile_pic': instance.profilePicUrl,
      'cover_pic': instance.coverPicUrl,
      'cosmos_account': instance.cosmosAccount?.toJson(),
    };
