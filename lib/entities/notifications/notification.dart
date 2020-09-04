import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/entities/notifications/post_notifications.dart';

part 'notification.g.dart';

/// Represents a generic notification and the contained data.
@immutable
@JsonSerializable(createFactory: false)
abstract class NotificationData extends Equatable {
  static const DATE_TYPE = 'type';
  static const DATE_FIELD = 'date';

  /// Represents the type of the notification.
  /// It must be one of the values present inside [NotificationTypes].
  @JsonKey(name: DATE_TYPE)
  final String type;

  /// Represents the data in which the notification has been created.
  @JsonKey(name: DATE_FIELD, toJson: dateToJson, fromJson: dateFromJson)
  final DateTime date;

  /// Returns the [date] field as a string.
  String get stringDate => DateFormat(_DATE_FORMAT).format(date);

  /// Represents the title of the notification that should be displayed
  /// inside the device.
  @JsonKey(name: 'title', nullable: true)
  final String title;

  /// Represents the body of the notification that should be displayed
  /// to the user.
  @JsonKey(name: 'body', nullable: true)
  final String body;

  /// Represents the action associated to this notification.
  /// If no action is associated, it will be `null`. Otherwise, it
  /// must be a value inside [NotificationActions] to be properly supported.
  @JsonKey(name: 'action', nullable: true)
  final String action;

  static const _DATE_FORMAT = "yyy-MM-dd'T'HH:mm:ss.SSS'Z'";

  static String dateToJson(DateTime time) {
    return DateFormat(_DATE_FORMAT).format(time);
  }

  static DateTime dateFromJson(String date) {
    return DateFormat(_DATE_FORMAT).parse(date);
  }

  const NotificationData({
    @required this.type,
    @required this.date,
    this.action,
    this.title,
    this.body,
  })  : assert(type != null),
        assert(date != null);

  @override
  List<Object> get props {
    return [
      type,
      DateFormat(_DATE_FORMAT).format(date),
      action,
      title,
      body,
    ];
  }

  /// Converts this instance into a JSON object properly.
  /// This relies on the `toJson` implementation to get the serialization
  /// of custom fields.
  Map<String, dynamic> asJson() {
    var base = _$NotificationDataToJson(this);
    // ignore: deprecated_member_use_from_same_package
    base.addAll(toJson());
    return base;
  }

  /// Leaves the implementation to the specific classes.
  /// NOTE: Do not use this method directly! Use [asJson] instead.
  @Deprecated('Use asJson instead')
  Map<String, dynamic> toJson();

  /// Calls the inheriting classes to build the correct notification based
  /// on the [type] field.
  factory NotificationData.fromJson(Map<String, dynamic> json) {
    final type = json[DATE_TYPE];

    // Posts
    if (type == NotificationTypes.COMMENT) {
      return PostCommentNotification.fromJson(json);
    } else if (type == NotificationTypes.REACTION) {
      return PostReactionNotification.fromJson(json);
    } else if (type == NotificationTypes.LIKE) {
      return PostLikeNotification.fromJson(json);
    } else if (type == NotificationTypes.MENTION) {
      return PostMentionNotification.fromJson(json);
    } else if (type == NotificationTypes.TAG) {
      return PostTagNotification.fromJson(json);
    }

    // Transactions
    else if (type == NotificationTypes.TRANSACTION_SUCCESS) {
      return TxSuccessfulNotification.fromJson(json);
    } else if (type == NotificationTypes.TRANSACTION_FAIL) {
      return TxFailedNotification.fromJson(json);
    }
    return null;
  }

  @override
  String toString() {
    return 'NotificationData {'
        'type: $type, '
        'date: $date, '
        'action: $action, '
        'title: $title, '
        'body: $body '
        '}';
  }
}
