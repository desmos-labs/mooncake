import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'tx_response.g.dart';

/// Represents the response that is returned upon querying the chain
/// for a specific transaction.
@JsonSerializable()
class TxResponse implements Equatable {
  @JsonKey(name: "txs")
  final List<Tx> txs;

  TxResponse({@required this.txs}) : assert(txs != null);

  @override
  List<Object> get props => [txs];

  @override
  String toString() => 'TxResponse {'
      'txs: $txs '
      '}';

  factory TxResponse.fromJson(Map<String, dynamic> json) =>
      _$TxResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TxResponseToJson(this);
}

/// Contains the content of a single transaction.
@JsonSerializable(explicitToJson: true)
class Tx implements Equatable {
  @JsonKey(name: "events")
  final List<MsgEvent> events;

  Tx({@required this.events}) : assert(events != null);

  @override
  List<Object> get props => [events];

  @override
  String toString() => 'Tx {'
      'events: $events '
      '}';

  factory Tx.fromJson(Map<String, dynamic> json) => _$TxFromJson(json);

  Map<String, dynamic> toJson() => _$TxToJson(this);
}

/// Contains the data of a single message that was emitted during the
/// handling of a transaction's messages.
@JsonSerializable(explicitToJson: true)
class MsgEvent implements Equatable {
  @JsonKey(name: "type")
  final String type;

  @JsonKey(name: "attributes")
  final List<Map<String, String>> attributes;

  MsgEvent({this.type, this.attributes})
      : assert(type != null),
        assert(attributes != null);

  @override
  List<Object> get props => [type, attributes];

  @override
  String toString() => 'MsgEvent {'
      'type: $type, '
      'attributes: $attributes '
      '}';

  factory MsgEvent.fromJson(Map<String, dynamic> json) =>
      _$MsgEventFromJson(json);

  Map<String, dynamic> toJson() => _$MsgEventToJson(this);
}
