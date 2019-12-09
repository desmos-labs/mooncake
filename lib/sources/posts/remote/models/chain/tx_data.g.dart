// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tx_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TxData _$TxDataFromJson(Map<String, dynamic> json) {
  return TxData(
    result: json['result'] == null
        ? null
        : TxResult.fromJson(json['result'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$TxDataToJson(TxData instance) => <String, dynamic>{
      'result': instance.result?.toJson(),
    };

TxResult _$TxResultFromJson(Map<String, dynamic> json) {
  return TxResult(
    events: (json['events'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, (e as List)?.map((e) => e as String)?.toList()),
    ),
  );
}

Map<String, dynamic> _$TxResultToJson(TxResult instance) => <String, dynamic>{
      'events': instance.events,
    };
