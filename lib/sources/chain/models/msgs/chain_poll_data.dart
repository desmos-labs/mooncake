import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import 'chain_poll_option.dart';

part 'chain_poll_data.g.dart';

/// Represents the object that should be sent to the chain when wanting
/// to crete a new message with a poll.
@immutable
@JsonSerializable(explicitToJson: true)
class ChainPollData {
  @JsonKey(name: 'question')
  final String question;

  @JsonKey(name: 'end_date')
  final String endDate;

  @JsonKey(name: 'allows_multiple_answers')
  final bool allowsMultipleAnswers;

  @JsonKey(name: 'allows_answer_edits')
  final bool allowsAnswerEdits;

  @JsonKey(name: 'provided_answers')
  final List<ChainPollOption> options;

  ChainPollData({
    @required this.question,
    @required this.endDate,
    @required this.options,
    @required this.allowsMultipleAnswers,
    @required this.allowsAnswerEdits,
  })  : assert(question != null),
        assert(endDate != null),
        assert(options != null),
        assert(allowsMultipleAnswers != null),
        assert(allowsAnswerEdits != null);

  factory ChainPollData.fromJson(Map<String, dynamic> json) {
    return _$ChainPollDataFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$ChainPollDataToJson(this);
  }
}
