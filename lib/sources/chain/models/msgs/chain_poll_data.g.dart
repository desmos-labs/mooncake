// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chain_poll_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChainPollData _$ChainPollDataFromJson(Map<String, dynamic> json) {
  return ChainPollData(
    question: json['question'] as String,
    endDate: json['end_date'] as String,
    options: (json['provided_answers'] as List)
        ?.map((e) => e == null
            ? null
            : ChainPollOption.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    allowsMultipleAnswers: json['allows_multiple_answers'] as bool,
    allowsAnswerEdits: json['allows_answer_edits'] as bool,
  );
}

Map<String, dynamic> _$ChainPollDataToJson(ChainPollData instance) =>
    <String, dynamic>{
      'question': instance.question,
      'end_date': instance.endDate,
      'allows_multiple_answers': instance.allowsMultipleAnswers,
      'allows_answer_edits': instance.allowsAnswerEdits,
      'provided_answers': instance.options?.map((e) => e?.toJson())?.toList(),
    };
