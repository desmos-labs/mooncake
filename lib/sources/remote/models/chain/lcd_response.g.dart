// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lcd_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LcdResponse _$LcdResponseFromJson(Map<String, dynamic> json) {
  return LcdResponse(
    height: json['height'] as String,
    result: json['result'] as Map<String, dynamic>,
  );
}

Map<String, dynamic> _$LcdResponseToJson(LcdResponse instance) =>
    <String, dynamic>{
      'height': instance.height,
      'result': instance.result,
    };
