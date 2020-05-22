// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'msg_create_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MsgCreateProfile _$MsgCreateProfileFromJson(Map<String, dynamic> json) {
  return MsgCreateProfile(
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

Map<String, dynamic> _$MsgCreateProfileToJson(MsgCreateProfile instance) {
  final val = <String, dynamic>{
    'moniker': instance.moniker,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('name', instance.name);
  writeNotNull('surname', instance.surname);
  writeNotNull('bio', instance.bio);
  writeNotNull('pictures', instance.pictures?.toJson());
  val['creator'] = instance.creator;
  return val;
}
