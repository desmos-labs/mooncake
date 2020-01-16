// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'msg_remove_post_reaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MsgRemovePostReaction _$MsgRemovePostReactionFromJson(
    Map<String, dynamic> json) {
  return MsgRemovePostReaction(
    postId: json['post_id'] as String,
    reaction: json['reaction'] as String,
    user: json['user'] as String,
  );
}

Map<String, dynamic> _$MsgRemovePostReactionToJson(
        MsgRemovePostReaction instance) =>
    <String, dynamic>{
      'post_id': instance.postId,
      'reaction': instance.reaction,
      'user': instance.user,
    };
