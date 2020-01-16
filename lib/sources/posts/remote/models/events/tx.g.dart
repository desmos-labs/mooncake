// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tx.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TxEvent _$TxEventFromJson(Map<String, dynamic> json) {
  return TxEvent(
    result: json['result'] == null
        ? null
        : TxEventResult.fromJson(json['result'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$TxEventToJson(TxEvent instance) => <String, dynamic>{
      'result': instance.result?.toJson(),
    };

TxEventResult _$TxEventResultFromJson(Map<String, dynamic> json) {
  return TxEventResult(
    data: json['data'] == null
        ? null
        : TxEventResultData.fromJson(json['data'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$TxEventResultToJson(TxEventResult instance) =>
    <String, dynamic>{
      'data': instance.data?.toJson(),
    };

TxEventResultData _$TxEventResultDataFromJson(Map<String, dynamic> json) {
  return TxEventResultData(
    type: json['type'] as String,
    value: json['value'] == null
        ? null
        : TxEventResultDataValue.fromJson(
            json['value'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$TxEventResultDataToJson(TxEventResultData instance) =>
    <String, dynamic>{
      'type': instance.type,
      'value': instance.value?.toJson(),
    };

TxEventResultDataValue _$TxEventResultDataValueFromJson(
    Map<String, dynamic> json) {
  return TxEventResultDataValue(
    txResult: json['TxResult'] == null
        ? null
        : TxResult.fromJson(json['TxResult'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$TxEventResultDataValueToJson(
        TxEventResultDataValue instance) =>
    <String, dynamic>{
      'TxResult': instance.txResult?.toJson(),
    };

TxResult _$TxResultFromJson(Map<String, dynamic> json) {
  return TxResult(
    height: json['height'] as String,
    index: json['index'] as int,
    tx: json['tx'] as String,
  );
}

Map<String, dynamic> _$TxResultToJson(TxResult instance) => <String, dynamic>{
      'height': instance.height,
      'index': instance.index,
      'tx': instance.tx,
    };
