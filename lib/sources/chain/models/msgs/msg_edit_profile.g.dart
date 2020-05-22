// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'msg_edit_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MsgEditProfile _$MsgEditProfileFromJson(Map<String, dynamic> json) {
  return MsgEditProfile(
    moniker: json['new_moniker'] as String,
    name: json['name'] as String,
    surname: json['surname'] as String,
    bio: json['bio'] as String,
    profilePicture: json['profile_pic'] as String,
    coverPicture: json['profile_cov'] as String,
    creator: json['creator'] as String,
  );
}

Map<String, dynamic> _$MsgEditProfileToJson(MsgEditProfile instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('new_moniker', instance.moniker);
  writeNotNull('name', instance.name);
  writeNotNull('surname', instance.surname);
  writeNotNull('bio', instance.bio);
  writeNotNull('profile_pic', instance.profilePicture);
  writeNotNull('profile_cov', instance.coverPicture);
  val['creator'] = instance.creator;
  return val;
}
