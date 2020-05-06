// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_poll.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostPoll _$PostPollFromJson(Map<String, dynamic> json) {
  return PostPoll(
    question: json['question'] as String,
    endDate: json['end_date'] == null
        ? null
        : DateTime.parse(json['end_date'] as String),
    options: (json['provided_answers'] as List)
        ?.map((e) =>
            e == null ? null : PollOption.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    isOpen: json['open'] as bool,
    allowsMultipleAnswers: json['allows_multiple_answers'] as bool,
    allowsAnswerEdits: json['allows_answer_edits'] as bool,
  );
}

Map<String, dynamic> _$PostPollToJson(PostPoll instance) => <String, dynamic>{
      'question': instance.question,
      'end_date': instance.endDate?.toIso8601String(),
      'provided_answers': instance.options?.map((e) => e?.toJson())?.toList(),
      'open': instance.isOpen,
      'allows_multiple_answers': instance.allowsMultipleAnswers,
      'allows_answer_edits': instance.allowsAnswerEdits,
    };
