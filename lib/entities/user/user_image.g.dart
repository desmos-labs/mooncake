// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$AccountImageToJson(AccountImage instance) =>
    <String, dynamic>{
      'type': _$AccountImageTypeEnumMap[instance.type],
    };

const _$AccountImageTypeEnumMap = {
  AccountImageType.LOCAL: 'local',
  AccountImageType.NETWORK: 'network',
  AccountImageType.NO_IMAGE: 'no_image',
};

NetworkUserImage _$NetworkImageFromJson(Map<String, dynamic> json) {
  return NetworkUserImage(
    json['url'] as String,
  );
}

Map<String, dynamic> _$NetworkImageToJson(NetworkUserImage instance) =>
    <String, dynamic>{
      'url': instance.url,
    };

NoUserImage _$NoImageFromJson(Map<String, dynamic> json) {
  return NoUserImage();
}

Map<String, dynamic> _$NoImageToJson(NoUserImage instance) => <String, dynamic>{};
