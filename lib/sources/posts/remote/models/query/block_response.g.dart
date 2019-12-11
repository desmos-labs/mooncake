// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'block_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlockResponse _$BlockResponseFromJson(Map<String, dynamic> json) {
  return BlockResponse(
    blockMeta: json['block_meta'] == null
        ? null
        : BlockMeta.fromJson(json['block_meta'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$BlockResponseToJson(BlockResponse instance) =>
    <String, dynamic>{
      'block_meta': instance.blockMeta?.toJson(),
    };

BlockMeta _$BlockMetaFromJson(Map<String, dynamic> json) {
  return BlockMeta(
    header: json['header'] == null
        ? null
        : BlockHeader.fromJson(json['header'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$BlockMetaToJson(BlockMeta instance) => <String, dynamic>{
      'header': instance.header?.toJson(),
    };

BlockHeader _$BlockHeaderFromJson(Map<String, dynamic> json) {
  return BlockHeader(
    height: json['height'] as String,
  );
}

Map<String, dynamic> _$BlockHeaderToJson(BlockHeader instance) =>
    <String, dynamic>{
      'height': instance.height,
    };
