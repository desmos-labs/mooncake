// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'msg_answer_poll.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MsgAnswerPoll _$MsgAnswerPollFromJson(Map<String, dynamic> json) {
  return MsgAnswerPoll(
    postId: json['post_id'] as String,
    answers: (json['answers'] as List)?.map((e) => e as String)?.toList(),
    user: json['answerer'] as String,
  );
}

Map<String, dynamic> _$MsgAnswerPollToJson(MsgAnswerPoll instance) =>
    <String, dynamic>{
      'post_id': instance.postId,
      'answers': instance.answers,
      'answerer': instance.user,
    };
