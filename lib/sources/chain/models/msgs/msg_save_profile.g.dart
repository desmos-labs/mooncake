// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'msg_save_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MsgSaveProfile _$MsgSaveProfileFromJson(Map<String, dynamic> json) {
  return MsgSaveProfile(
    dtag: json['dtag'] as String,
    moniker: json['moniker'] as String,
    bio: json['bio'] as String,
    profilePic: json['profile_picture'] as String,
    coverPic: json['cover_picture'] as String,
    creator: json['creator'] as String,
  );
}

Map<String, dynamic> _$MsgSaveProfileToJson(MsgSaveProfile instance) {
  final val = <String, dynamic>{
    'dtag': instance.dtag,
    'moniker': instance.moniker,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('bio', instance.bio);
  writeNotNull('profile_picture', instance.profilePic);
  writeNotNull('cover_picture', instance.coverPic);
  val['creator'] = instance.creator;
  return val;
}
