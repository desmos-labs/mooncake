import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

part 'fcm_message_data.g.dart';

/// Represents the message object sent from the server upon a new notification
/// is created.
@immutable
@JsonSerializable(explicitToJson: true)
class FcmMessage extends Equatable {
  @JsonKey(name: "notification", required: false)
  final FcmNotification notification;

  @JsonKey(name: "data", required: true)
  final Map<String, dynamic> data;

  FcmMessage({this.notification, this.data});

  @override
  List<Object> get props => [notification, data];

  factory FcmMessage.fromJson(Map<String, dynamic> json) {
    final newJson = json.map((key, value) => MapEntry(
          key,
          (value is LinkedHashMap) ? Map<String, dynamic>.from(value) : value,
        ));
    return _$FcmMessageFromJson(newJson);
  }

  Map<String, dynamic> toJson() => _$FcmMessageToJson(this);
}

/// Contains the notification data present inside an [FcmMessage].
@immutable
@JsonSerializable(explicitToJson: true)
class FcmNotification extends Equatable {
  @JsonKey(name: "title", required: false)
  final String title;

  @JsonKey(name: "body", required: false)
  final String body;

  @JsonKey(name: "image", required: false)
  final String imageUrl;

  FcmNotification({
    @required this.title,
    @required this.body,
    @required this.imageUrl,
  });

  @override
  List<Object> get props => [title, body, imageUrl];

  factory FcmNotification.fromJson(Map<String, dynamic> json) =>
      _$FcmNotificationFromJson(Map.from(json));

  Map<String, dynamic> toJson() => _$FcmNotificationToJson(this);
}

/// Represents the data object that can be sent along with
/// any FCM notification.
@immutable
@JsonSerializable(explicitToJson: true)
class FcmOpenPostData extends Equatable {
  static const ACTION_SHOW_POST = "showPost";

  @JsonKey(name: "action")
  final String action;

  @JsonKey(name: "post_id")
  final String postId;

  FcmOpenPostData({
    this.action,
    this.postId,
  });

  @override
  List<Object> get props => [action, postId];

  factory FcmOpenPostData.fromJson(Map<String, dynamic> json) =>
      _$FcmOpenPostDataFromJson(Map.from(json));

  Map<String, dynamic> toJson() => _$FcmOpenPostDataToJson(this);
}
