// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ipfs_upload_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IpfsUploadResponse _$IpfsUploadResponseFromJson(Map<String, dynamic> json) {
  return IpfsUploadResponse(
    name: json['Name'] as String,
    hash: json['Hash'] as String,
    size: json['Size'] as String,
  );
}

Map<String, dynamic> _$IpfsUploadResponseToJson(IpfsUploadResponse instance) =>
    <String, dynamic>{
      'Name': instance.name,
      'Hash': instance.hash,
      'Size': instance.size,
    };
