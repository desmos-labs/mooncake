import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'chain_poll_option.g.dart';

/// Represents a single option inside a post poll.
@immutable
@JsonSerializable(explicitToJson: true)
class ChainPollOption {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'text')
  final String text;

  ChainPollOption({
    @required this.id,
    @required this.text,
  })  : assert(id != null),
        assert(text != null);

  factory ChainPollOption.fromJson(Map<String, dynamic> json) {
    return _$ChainPollOptionFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$ChainPollOptionToJson(this);
  }
}
