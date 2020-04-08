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
  /// Contains the data of the notification.
  @JsonKey(name: "notification", nullable: true)
  final FcmNotification notification;

  /// Contains the data associated to the notification.
  @JsonKey(name: "data", nullable: false)
  final Map<String, dynamic> data;

  /// Returns the associated action.
  /// If no action is associated, it returns `null` instead.
  String get action => data["action"];

  /// Returns the associated type.
  /// If no type is associated, it returns `null` instead.
  String get type => data["type"];

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
