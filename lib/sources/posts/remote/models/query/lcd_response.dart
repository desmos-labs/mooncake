import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'lcd_response.g.dart';

/// Represents the data present inside a response that is returned from
/// the LCD upon querying any endpoint.
@JsonSerializable()
class LcdResponse extends Equatable {
  @JsonKey(name: "height")
  final String height;

  @JsonKey(name: "result")
  final Map<String, dynamic> result;

  LcdResponse({
    this.height,
    this.result,
  })  : assert(height != null),
        assert(result != null);

  @override
  List<Object> get props => [height, result];

  @override
  String toString() => 'LcdResponse {'
      'height: $height, '
      'result: $result '
      '}';

  factory LcdResponse.fromJson(Map<String, dynamic> json) =>
      _$LcdResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LcdResponseToJson(this);
}
