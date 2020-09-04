import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'poll_option.g.dart';

/// Represents a poll option that can be selected from users answering this
/// poll.
@immutable
@JsonSerializable(explicitToJson: true)
class PollOption extends Equatable {
  /// Id of the option.
  /// This same id will be used by users in order to reference this option when
  /// answering the poll. For this reason, it will be used inside
  /// [PollAnswer.id] field.
  @JsonKey(name: 'id')
  final int id;

  /// Textual option that the user will be able to read inside the poll.
  @JsonKey(name: 'text')
  final String text;

  const PollOption({
    @required this.id,
    @required this.text,
  })  : assert(id != null),
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
      id: index ?? id,
      text: text ?? this.text,
    );
  }

  @override
  List<Object> get props {
    return [id, text];
  }
}
