import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mooncake/entities/entities.dart';

part 'post_poll.g.dart';

/// Represents a poll that can be present inside a post.
@immutable
@JsonSerializable(explicitToJson: true)
class PostPoll extends Equatable {
  @JsonKey(name: "question")
  final String question;

  @JsonKey(name: "end_date")
  final DateTime endDate;

  @JsonKey(name: "provided_answers")
  final List<PollOption> options;

  @JsonKey(name: "open")
  final bool isOpen;

  @JsonKey(name: "allows_multiple_answers")
  final bool allowsMultipleAnswers;

  @JsonKey(name: "allows_answer_edits")
  final bool allowsAnswerEdits;

  PostPoll({
    @required this.question,
    @required this.endDate,
    @required this.options,
    @required this.isOpen,
    @required this.allowsMultipleAnswers,
    @required this.allowsAnswerEdits,
  })  : assert(question != null),
        assert(endDate != null),
        assert(options != null),
        assert(isOpen != null),
        assert(allowsMultipleAnswers != null),
        assert(allowsAnswerEdits != null);

  bool get isValid {
    return question?.isNotEmpty == true &&
        endDate != null &&
        options?.isNotEmpty == true;
  }

  factory PostPoll.empty() {
    return PostPoll(
      question: "",
      endDate: DateTime.now().add(Duration(days: 30)),
      options: [
        PollOption(text: "", id: 0),
        PollOption(text: "", id: 1),
      ],
      isOpen: true,
      allowsMultipleAnswers: false,
      allowsAnswerEdits: false,
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
    bool isOpen,
    bool allowsMultipleAnswers,
    bool allowsAnswerEdits,
  }) {
    return PostPoll(
      question: question ?? this.question,
      endDate: endDate ?? this.endDate,
      options: options ?? this.options,
      isOpen: isOpen ?? this.isOpen,
      allowsMultipleAnswers:
          allowsMultipleAnswers ?? this.allowsMultipleAnswers,
      allowsAnswerEdits: allowsAnswerEdits ?? this.allowsAnswerEdits,
    );
  }

  @override
  List<Object> get props {
    return [
      question,
      endDate,
      options,
      isOpen,
      allowsMultipleAnswers,
      allowsAnswerEdits,
    ];
  }

  @override
  String toString() {
    return 'PostPoll {'
        'question: $question, '
        'endDate: $endDate, '
        'options: $options, '
        'isOpen: $isOpen, '
        'allowsMultipleAnswers: $allowsMultipleAnswers, '
        'allowsAnswerEdits: $allowsAnswerEdits '
        '}';
  }
}
