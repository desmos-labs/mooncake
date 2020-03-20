import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';

part 'transaction_notifications.g.dart';

/// Represents a generic notification tied to a specific transaction.
@immutable
abstract class TxNotification extends NotificationData {
  @JsonKey(name: "tx_hash")
  final String txHash;

  TxNotification({
    @required String type,
    @required DateTime date,
    @required this.txHash,
  })  : assert(txHash != null),
        super(
          type: type,
          date: date,
        );

  @override
  List<Object> get props => super.props + [txHash];
}

/// Represents the notification that is sent to the user after a transaction
/// has been marked as successful.
@immutable
@JsonSerializable(explicitToJson: true)
class TxSuccessfulNotification extends TxNotification {
  TxSuccessfulNotification({
    @required DateTime date,
    @required String txHash,
  }) : super(
          type: NotificationTypes.TRANSACTION_SUCCESS,
          date: date,
          txHash: txHash,
        );

  factory TxSuccessfulNotification.fromJson(Map<String, dynamic> json) =>
      _$TxSuccessfulNotificationFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TxSuccessfulNotificationToJson(this);
}

/// Represents the notification that is sent to the user when
/// a transaction fails.
@immutable
@JsonSerializable(explicitToJson: true)
class TxFailedNotification extends TxNotification {
  @JsonKey(name: "error")
  final String error;

  TxFailedNotification({
    @required DateTime date,
    @required String txHash,
    @required this.error,
  })  : assert(error != null),
        super(
          type: NotificationTypes.TRANSACTION_FAIL,
          date: date,
          txHash: txHash,
        );

  factory TxFailedNotification.fromJson(Map<String, dynamic> json) =>
      _$TxFailedNotificationFromJson(json);

  @override
  List<Object> get props => super.props + [error];

  @override
  Map<String, dynamic> toJson() => _$TxFailedNotificationToJson(this);
}
