import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'fcm_message_data.g.dart';

/// Represents the message object sent from the server upon a new notification
/// is created.
//class FcmMessage extends Equatable {
//  final Notification notification;
//
//  @JsonKey(name: "data")
//  final FcmMessageData data;
//}

/// Represents the data object that can be sent along with
/// any FCM notification.
@JsonSerializable(explicitToJson: true)
class FcmMessageData extends Equatable {
  static const ACTION_SHOW_POST = "showPost";

  @JsonKey(name: "action")
  final String action;

  @JsonKey(name: "post_id")
  final String postId;

  FcmMessageData({
    this.action,
    this.postId,
  });

  @override
  List<Object> get props => [action, postId];

  factory FcmMessageData.fromJson(Map<String, dynamic> json) =>
      _$FcmMessageDataFromJson(json);

  Map<String, dynamic> toJson() => _$FcmMessageDataToJson(this);
}
