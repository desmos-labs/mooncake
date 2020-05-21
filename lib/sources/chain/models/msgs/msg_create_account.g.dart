// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'msg_create_account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MsgCreateAccount _$MsgCreateAccountFromJson(Map<String, dynamic> json) {
  return MsgCreateAccount(
    moniker: json['moniker'] as String,
    name: json['name'] as String,
    surname: json['surname'] as String,
    bio: json['bio'] as String,
    pictures: json['pictures'] == null
        ? null
        : UserPictures.fromJson(json['pictures'] as Map<String, dynamic>),
    creator: json['creator'] as String,
  );
}

Map<String, dynamic> _$MsgCreateAccountToJson(MsgCreateAccount instance) =>
    <String, dynamic>{
      'moniker': instance.moniker,
      'name': instance.name,
      'surname': instance.surname,
      'bio': instance.bio,
      'pictures': instance.pictures?.toJson(),
      'creator': instance.creator,
    };
