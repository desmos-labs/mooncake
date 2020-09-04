import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

part 'fcm_message_data.g.dart';

/// Represents the message object sent from the server upon a new notification
/// is created.
@immutable
@JsonSerializable(explicitToJson: true)
class FcmMessage extends Equatable {
  /// Represents the key that is used in order to contain the notification data.
  static const NOTIFICATION_KEY = 'notification';

  /// Represents the key that is used in order to contain custom data.
  static const DATA_KEY = 'data';

  /// Contains the data of the notification.
  @JsonKey(name: NOTIFICATION_KEY, nullable: true)
  final FcmNotification notification;

  /// Contains the data associated to the notification.
  @JsonKey(name: DATA_KEY, nullable: false)
  final Map<String, dynamic> data;

  /// Returns the associated action.
  /// If no action is associated, it returns `null` instead.
  String get action => data['action'] as String;

  /// Returns the associated type.
  /// If no type is associated, it returns `null` instead.
  String get type => data['type'] as String;

  FcmMessage({this.notification, this.data});

  @override
  List<Object> get props => [notification, data];

  /// Takes a `Map<dynamic, dynamic>` and converts it to a
  /// `Map<string, dynamic>`. All its values which represent a [Map] are
  /// also converted to make sure they are all of type `Map<String, dynamic>`.
  static Map<String, dynamic> _convertMap(Map<dynamic, dynamic> map) {
    return map.map((key, value) {
      if (value is Map<dynamic, dynamic>) {
        value = _convertMap(value as Map<dynamic, dynamic>);
      }

      return MapEntry(key as String, value);
    });
  }

  factory FcmMessage.fromJson(Map<String, dynamic> json) {
    if (json[DATA_KEY] == null) {
      final entries = json.entries
          .where((e) => e.key != NOTIFICATION_KEY && e.key != DATA_KEY)
          .toList();
      json[DATA_KEY] = Map.fromEntries(entries);
    }

    return _$FcmMessageFromJson(_convertMap(json));
  }

  Map<String, dynamic> toJson() {
    return _$FcmMessageToJson(this);
  }
}

/// Contains the notification data present inside an [FcmMessage].
@immutable
@JsonSerializable(explicitToJson: true)
class FcmNotification extends Equatable {
  @JsonKey(name: 'title', required: false)
  final String title;

  @JsonKey(name: 'body', required: false)
  final String body;

  @JsonKey(name: 'image', required: false)
  final String imageUrl;

  FcmNotification({
    @required this.title,
    @required this.body,
    @required this.imageUrl,
  });

  @override
  List<Object> get props => [title, body, imageUrl];

  factory FcmNotification.fromJson(Map<String, dynamic> json) {
    return _$FcmNotificationFromJson(Map.from(json));
  }

  Map<String, dynamic> toJson() {
    return _$FcmNotificationToJson(this);
  }
}
