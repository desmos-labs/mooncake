// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poll_answer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PollAnswer _$PollAnswerFromJson(Map<String, dynamic> json) {
  return PollAnswer(
    answer: json['answer'] as int,
    user: json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$PollAnswerToJson(PollAnswer instance) =>
    <String, dynamic>{
      'answer': instance.answer,
      'user': instance.user?.toJson(),
    };
