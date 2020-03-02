import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';

part 'notification.g.dart';

/// Represents the type of the notification.
enum NotificationDataType {
  @JsonValue("COMMENT")
  comment,

  @JsonValue("LIKE")
  like,

  @JsonValue("REACTION")
  reaction,

  @JsonValue("MENTION")
  mention
}

/// Represents a generic notification.
@immutable
@JsonSerializable(explicitToJson: true)
class NotificationData extends Equatable {
  static const String DATE_FIELD = "date";
  static const String DATE_FORMAT = "yyyy-MM-dd'T'HH:mm:ss.sssZ";

  @JsonKey(name: "type")
  final NotificationDataType type;

  @JsonKey(name: "user")
  final User user;

  @JsonKey(name: DATE_FIELD)
  final String date;

  /// Returns the [DateTime] associated with the given date.
  DateTime get dateTime => DateFormat(DATE_FORMAT).parse(date);

  @JsonKey(name: "data", nullable: true)
  final String data;

  @JsonKey(name: "image_url", nullable: true)
  final String imageUrl;

  NotificationData({
    @required this.type,
    @required this.user,
    @required this.date,
    this.data,
    this.imageUrl,
  })  : assert(type != null),
        assert(user != null),
        assert(date != null);

  factory NotificationData.fromJson(Map<String, dynamic> json) =>
      _$NotificationDataFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationDataToJson(this);

  @override
  List<Object> get props => [type, user, date, data, imageUrl];
}
