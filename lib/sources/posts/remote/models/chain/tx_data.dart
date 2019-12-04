import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'tx_data.g.dart';

/// Contains the data that are sent from the websocket each time
/// a new transaction is added to the chain.
@JsonSerializable(explicitToJson: true)
class TxData extends Equatable {
  final TxResult result;

  TxData({@required this.result}) : assert(result != null);

  @override
  List<Object> get props => [result];

  factory TxData.fromJson(Map<String, dynamic> json) => _$TxDataFromJson(json);

  Map<String, dynamic> toJson() => _$TxDataToJson(this);

  @override
  String toString() => 'TxData { result: $result }';
}

/// Contains the data present inside the "result" field of
/// a [TxData] object.
@JsonSerializable(explicitToJson: true)
class TxResult extends Equatable {
  final Map<String, List<String>> events;

  TxResult({@required this.events}) : assert(events != null);

  @override
  List<Object> get props => [events];

  factory TxResult.fromJson(Map<String, dynamic> json) =>
      _$TxResultFromJson(json);

  Map<String, dynamic> toJson() => _$TxResultToJson(this);

  @override
  String toString() => 'TxResult { events: $events }';
}
