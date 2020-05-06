import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'poll_option.g.dart';

/// Represents a poll option that can be selected from users answering this
/// poll.
@immutable
@JsonSerializable(explicitToJson: true)
class PollOption extends Equatable {
  final int index;
  final String text;

  PollOption({
    @required this.index,
    @required this.text,
  })  : assert(index != null),
        assert(text != null);

  factory PollOption.fromJson(Map<String, dynamic> json) {
    return _$PollOptionFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$PollOptionToJson(this);
  }

  PollOption copyWith({
    int index,
    String text,
  }) {
    return PollOption(
      index: index ?? this.index,
      text: text ?? this.text,
    );
  }

  @override
  List<Object> get props => [index, text];
}
