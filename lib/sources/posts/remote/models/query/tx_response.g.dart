// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tx_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TxResponse _$TxResponseFromJson(Map<String, dynamic> json) {
  return TxResponse(
    txs: (json['txs'] as List)
        ?.map((e) => e == null ? null : Tx.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$TxResponseToJson(TxResponse instance) =>
    <String, dynamic>{
      'txs': instance.txs,
    };

Tx _$TxFromJson(Map<String, dynamic> json) {
  return Tx(
    events: (json['events'] as List)
        ?.map((e) =>
            e == null ? null : MsgEvent.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$TxToJson(Tx instance) => <String, dynamic>{
      'events': instance.events?.map((e) => e?.toJson())?.toList(),
    };

MsgEvent _$MsgEventFromJson(Map<String, dynamic> json) {
  return MsgEvent(
    type: json['type'] as String,
    attributes: (json['attributes'] as List)
        ?.map((e) => (e as Map<String, dynamic>)?.map(
              (k, e) => MapEntry(k, e as String),
            ))
        ?.toList(),
  );
}

Map<String, dynamic> _$MsgEventToJson(MsgEvent instance) => <String, dynamic>{
      'type': instance.type,
      'attributes': instance.attributes,
    };
