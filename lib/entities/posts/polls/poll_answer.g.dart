// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poll_answer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PollAnswer _$PollAnswerFromJson(Map<String, dynamic> json) {
  return PollAnswer(
    answers: (json['answers'] as List)?.map((e) => e as int)?.toList(),
    user: json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$PollAnswerToJson(PollAnswer instance) =>
    <String, dynamic>{
      'answers': instance.answers,
      'user': instance.user?.toJson(),
    };
