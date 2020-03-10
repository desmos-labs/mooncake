// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_notifications.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostCommentNotification _$PostCommentNotificationFromJson(
    Map<String, dynamic> json) {
  return PostCommentNotification(
    postId: json['post_id'] as String,
    user: User.fromJson(json['user'] as Map<String, dynamic>),
    comment: json['message'] as String,
    date: NotificationData.dateFromJson(json['date'] as String),
    title: json['title'] as String,
    body: json['body'] as String,
  );
}

Map<String, dynamic> _$PostCommentNotificationToJson(
        PostCommentNotification instance) =>
    <String, dynamic>{
      'date': NotificationData.dateToJson(instance.date),
      'title': instance.title,
      'body': instance.body,
      'post_id': instance.postId,
      'user': instance.user.toJson(),
      'message': instance.comment,
    };

PostMentionNotification _$PostMentionNotificationFromJson(
    Map<String, dynamic> json) {
  return PostMentionNotification(
    postId: json['post_id'] as String,
    user: User.fromJson(json['user'] as Map<String, dynamic>),
    date: NotificationData.dateFromJson(json['date'] as String),
    text: json['text'] as String,
    title: json['title'] as String,
    body: json['body'] as String,
  );
}

Map<String, dynamic> _$PostMentionNotificationToJson(
        PostMentionNotification instance) =>
    <String, dynamic>{
      'date': NotificationData.dateToJson(instance.date),
      'title': instance.title,
      'body': instance.body,
      'post_id': instance.postId,
      'user': instance.user.toJson(),
      'text': instance.text,
    };

PostTagNotification _$PostTagNotificationFromJson(Map<String, dynamic> json) {
  return PostTagNotification(
    postId: json['post_id'] as String,
    user: User.fromJson(json['user'] as Map<String, dynamic>),
    date: NotificationData.dateFromJson(json['date'] as String),
    title: json['title'] as String,
    body: json['body'] as String,
  );
}

Map<String, dynamic> _$PostTagNotificationToJson(
        PostTagNotification instance) =>
    <String, dynamic>{
      'date': NotificationData.dateToJson(instance.date),
      'title': instance.title,
      'body': instance.body,
      'post_id': instance.postId,
      'user': instance.user.toJson(),
    };

PostReactionNotification _$PostReactionNotificationFromJson(
    Map<String, dynamic> json) {
  return PostReactionNotification(
    postId: json['post_id'] as String,
    user: User.fromJson(json['user'] as Map<String, dynamic>),
    date: NotificationData.dateFromJson(json['date'] as String),
    reaction: json['reaction'] as String,
    title: json['title'] as String,
    body: json['body'] as String,
  );
}

Map<String, dynamic> _$PostReactionNotificationToJson(
        PostReactionNotification instance) =>
    <String, dynamic>{
      'date': NotificationData.dateToJson(instance.date),
      'title': instance.title,
      'body': instance.body,
      'post_id': instance.postId,
      'user': instance.user.toJson(),
      'reaction': instance.reaction,
    };

PostLikeNotification _$PostLikeNotificationFromJson(Map<String, dynamic> json) {
  return PostLikeNotification(
    postId: json['post_id'] as String,
    user: User.fromJson(json['user'] as Map<String, dynamic>),
    date: NotificationData.dateFromJson(json['date'] as String),
    title: json['title'] as String,
    body: json['body'] as String,
  );
}

Map<String, dynamic> _$PostLikeNotificationToJson(
        PostLikeNotification instance) =>
    <String, dynamic>{
      'date': NotificationData.dateToJson(instance.date),
      'title': instance.title,
      'body': instance.body,
      'post_id': instance.postId,
      'user': instance.user.toJson(),
    };
