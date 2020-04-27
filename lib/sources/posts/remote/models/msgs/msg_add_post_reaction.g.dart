// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'msg_add_post_reaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MsgAddPostReaction _$MsgAddPostReactionFromJson(Map<String, dynamic> json) {
  return MsgAddPostReaction(
    postId: json['post_id'] as String,
    reaction: json['reaction'] as String,
    user: json['user'] as String,
  );
}

Map<String, dynamic> _$MsgAddPostReactionToJson(MsgAddPostReaction instance) =>
    <String, dynamic>{
      'post_id': instance.postId,
      'reaction': instance.reaction,
      'user': instance.user,
    };
