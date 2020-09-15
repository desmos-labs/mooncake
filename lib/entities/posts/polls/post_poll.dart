import 'dart:convert';

import 'package:crypto/crypto.dart';
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
  static const USER_ANSWERS_FIELD = 'user_answers';
  static const END_DATE_FIELD= 'end_date';

  /// Question associated to this poll.
  @JsonKey(name: 'question')
  final String question;

  /// Ending date of the poll. After this date, the user should not be
  /// allowed to answer the poll anymore.
  @JsonKey(name: END_DATE_FIELD)
  final String endDate;

  /// Tells whether the post allows a single user to answer multiple
  /// times to it (so it is a checkbox-based poll) or if it allows only one
  /// answer per user.
  @JsonKey(name: 'allows_multiple_answers')
  final bool allowsMultipleAnswers;

  /// Tells whether the user should be allowed to change his mind once he
  /// has voted, or if the answer should be locked when added.
  @JsonKey(name: 'allows_answer_edits')
  final bool allowsAnswerEdits;

  /// List of all the available options that the user can choose from.
  @JsonKey(name: 'available_answers')
  final List<PollOption> options;

  /// List of all the user answers that have been added to this poll.
  @JsonKey(name: USER_ANSWERS_FIELD)
  final List<PollAnswer> userAnswers;

  const PostPoll({
    @required this.question,
    @required this.endDate,
    @required this.options,
    @required this.allowsMultipleAnswers,
    @required this.allowsAnswerEdits,
    List<PollAnswer> userAnswers = const [],
  })  : assert(question != null),
        assert(endDate != null),
        assert(options != null),
        assert(allowsMultipleAnswers != null),
        assert(allowsAnswerEdits != null),
        userAnswers = userAnswers ?? const [];

  /// Allows to create an empty [PostPoll] object.
  factory PostPoll.empty() {
    return PostPoll(
      question: '',
      endDate: DateFormat(Post.DATE_FORMAT)
          .format(DateTime.now().add(Duration(days: 30)).toUtc()),
      options: [
        PollOption(text: '', id: 0),
        PollOption(text: '', id: 1),
      ],
      allowsMultipleAnswers: false,
      allowsAnswerEdits: false,
    );
  }

  /// Takes the given [json] JSON object and creates a [PostPoll] from it.
  factory PostPoll.fromJson(Map<String, dynamic> json) {
    return _$PostPollFromJson(json);
  }

  /// Returns the [endDate] as a [DateTime] object.
  DateTime get endDateTime {
    return DateTime.parse(endDate);
  }

  /// Returns `true` if this post is valid, meaning it has a non-empty question
  /// as well as **at least** two different options provided.
  bool get isValid {
    return question?.isNotEmpty == true &&
        endDate != null &&
        options?.isNotEmpty == true;
  }

  /// Tells if the poll is still open or not based on the current date time.
  bool get isOpen {
    return DateTime.now().isBefore(endDateTime);
  }

  /// Returns the JSON representation of this post poll as a [Map].
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
      endDate:
          DateFormat(Post.DATE_FORMAT).format(endDate?.toUtc() ?? endDateTime),
      options: options ?? this.options,
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
        'allowsMultipleAnswers: $allowsMultipleAnswers, '
        'allowsAnswerEdits: $allowsAnswerEdits,'
        'userAnswers: $userAnswers  '
        '}';
  }
}
