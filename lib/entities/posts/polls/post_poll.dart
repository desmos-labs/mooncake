import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mooncake/entities/entities.dart';

part 'post_poll.g.dart';

@immutable
@JsonSerializable(explicitToJson: true)
class PostPoll extends Equatable {
  final String question;
  final DateTime endDate;
  final List<PollOption> options;

  PostPoll({
    @required this.question,
    @required this.endDate,
    @required this.options,
  })  : assert(question != null),
        assert(endDate != null),
        assert(options != null);

  factory PostPoll.empty() {
    return PostPoll(
      question: "",
      endDate: DateTime.now().add(Duration(days: 30)),
      options: [
        PollOption(text: "", index: 0),
        PollOption(text: "", index: 1),
      ],
    );
  }

  factory PostPoll.fromJson(Map<String, dynamic> json) {
    return _$PostPollFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$PostPollToJson(this);
  }

  PostPoll copyWith({
    String question,
    DateTime endDate,
    List<PollOption> options,
  }) {
    return PostPoll(
      question: question ?? this.question,
      endDate: endDate ?? this.endDate,
      options: options ?? this.options,
    );
  }

  @override
  List<Object> get props => [question, endDate, options];

  @override
  String toString() {
    return 'PostPoll {'
        'question: $question, '
        'endDate: $endDate, '
        'options: $options, '
        '}';
  }
}
