import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'tx_event.g.dart';

/// Contains the data that are sent from the websocket each time
/// a new transaction is added to the chain.
@JsonSerializable(explicitToJson: true)
class TxEvent extends Equatable {
  @JsonKey(name: "result")
  final TxEventResult result;

  TxEvent({@required this.result}) : assert(result != null);

  @override
  List<Object> get props => [result];

  @override
  String toString() => 'TxEvent { result: $result }';

  factory TxEvent.fromJson(Map<String, dynamic> json) =>
      _$TxEventFromJson(json);

  Map<String, dynamic> toJson() => _$TxEventToJson(this);
}

/// Contains the data present inside the "result" field of
/// a [TxEvent] object.
@JsonSerializable(explicitToJson: true)
class TxEventResult extends Equatable {
  @JsonKey(name: "data")
  final TxEventResultData data;

  TxEventResult({@required this.data}) : assert(data != null);

  @override
  List<Object> get props => [data];

  @override
  String toString() => 'TxEventResult { '
      'data: $data '
      '}';

  factory TxEventResult.fromJson(Map<String, dynamic> json) =>
      _$TxEventResultFromJson(json);

  Map<String, dynamic> toJson() => _$TxEventResultToJson(this);
}

/// Contains the data present inside the "data" event of a [TxEventResult].
@JsonSerializable(explicitToJson: true)
class TxEventResultData extends Equatable {
  @JsonKey(name: "type")
  final String type;

  @JsonKey(name: "value")
  final TxEventResultDataValue value;

  TxEventResultData({
    @required this.type,
    @required this.value,
  })  : assert(type != null),
        assert(value != null);

  @override
  List<Object> get props => [type, value];

  @override
  String toString() => 'TxEventResultData { '
      'type: $type, '
      'value: $value '
      '}';

  factory TxEventResultData.fromJson(Map<String, dynamic> json) =>
      _$TxEventResultDataFromJson(json);

  Map<String, dynamic> toJson() => _$TxEventResultDataToJson(this);
}

/// Contains the data of the "value" field of a [TxEventResultData].
@JsonSerializable(explicitToJson: true)
class TxEventResultDataValue extends Equatable {
  @JsonKey(name: "TxResult")
  final TxResult txResult;

  TxEventResultDataValue({@required this.txResult}) : assert(txResult != null);

  @override
  List<Object> get props => [txResult];

  @override
  String toString() => 'TxEventResultDataValue { txResult: $txResult }';

  factory TxEventResultDataValue.fromJson(Map<String, dynamic> json) =>
      _$TxEventResultDataValueFromJson(json);

  Map<String, dynamic> toJson() => _$TxEventResultDataValueToJson(this);
}

/// Contains the data present inside the "result" field of a
/// [TxQueryResultData] when the type if "TxResult".
@JsonSerializable(explicitToJson: true)
class TxResult extends Equatable {
  @JsonKey(name: "height")
  final String height;

  @JsonKey(name: "index")
  final int index;

  @JsonKey(name: "tx")
  final String tx;

  TxResult({
    @required this.height,
    @required this.index,
    @required this.tx,
  })  : assert(height != null),
        assert(index != null),
        assert(tx != null);

  @override
  List<Object> get props => [height, index, tx];

  @override
  String toString() => 'TxResult { '
      'height: $height, '
      'index: $index, '
      'tx: $tx '
      '}';

  factory TxResult.fromJson(Map<String, dynamic> json) =>
      _$TxResultFromJson(json);

  Map<String, dynamic> toJson() => _$TxResultToJson(this);
}
