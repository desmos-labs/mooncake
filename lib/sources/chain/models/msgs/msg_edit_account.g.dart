// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'msg_edit_account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MsgEditAccount _$MsgEditAccountFromJson(Map<String, dynamic> json) {
  return MsgEditAccount(
    moniker: json['new_moniker'] as String,
    name: json['name'] as String,
    surname: json['surname'] as String,
    bio: json['bio'] as String,
    profilePicture: json['profile_pic'] as String,
    coverPicture: json['profile_cov'] as String,
    creator: json['creator'] as String,
  );
}

Map<String, dynamic> _$MsgEditAccountToJson(MsgEditAccount instance) =>
    <String, dynamic>{
      'new_moniker': instance.moniker,
      'name': instance.name,
      'surname': instance.surname,
      'bio': instance.bio,
      'profile_pic': instance.profilePicture,
      'profile_cov': instance.coverPicture,
      'creator': instance.creator,
    };
