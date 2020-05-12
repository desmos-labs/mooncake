import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
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
  final String endDate;

  DateTime get endDateTime {
    return DateTime.parse(endDate);
  }

  @JsonKey(name: "open")
  final bool isOpen;

  @JsonKey(name: "allows_multiple_answers")
  final bool allowsMultipleAnswers;

  @JsonKey(name: "allows_answer_edits")
  final bool allowsAnswerEdits;

  @JsonKey(name: "available_answers")
  final List<PollOption> options;

  @JsonKey(name: "user_answers")
  final List<PollAnswer> userAnswers;

  bool get isValid {
    return question?.isNotEmpty == true &&
        endDate != null &&
        options?.isNotEmpty == true;
  }

  PostPoll({
    @required this.question,
    @required this.endDate,
    @required this.options,
    @required this.isOpen,
    @required this.allowsMultipleAnswers,
    @required this.allowsAnswerEdits,
    List<PollAnswer> userAnswers = const [],
  })  : assert(question != null),
        assert(endDate != null),
        assert(options != null),
        assert(isOpen != null),
        assert(allowsMultipleAnswers != null),
        assert(allowsAnswerEdits != null),
        userAnswers = userAnswers ?? [];

  factory PostPoll.empty() {
    return PostPoll(
      question: "",
      endDate: DateFormat(Post.DATE_FORMAT)
          .format(DateTime.now().add(Duration(days: 30)).toUtc()),
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
    List<PollAnswer> userAnswers,
  }) {
    return PostPoll(
      question: question ?? this.question,
      endDate: DateFormat(Post.DATE_FORMAT)
          .format(endDate?.toUtc() ?? this.endDateTime),
      options: options ?? this.options,
      isOpen: isOpen ?? this.isOpen,
      allowsMultipleAnswers:
          allowsMultipleAnswers ?? this.allowsMultipleAnswers,
      allowsAnswerEdits: allowsAnswerEdits ?? this.allowsAnswerEdits,
      userAnswers: userAnswers ?? this.userAnswers,
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
      userAnswers,
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
        'allowsAnswerEdits: $allowsAnswerEdits,'
        'userAnswers: $userAnswers  '
        '}';
  }
}
