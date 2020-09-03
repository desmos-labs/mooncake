import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';

part 'transaction_notifications.g.dart';

/// Represents a generic notification tied to a specific transaction.
@immutable
abstract class TxNotification extends NotificationData {
  @JsonKey(name: 'tx_hash')
  final String txHash;

  const TxNotification({
    @required String type,
    @required DateTime date,
    @required this.txHash,
  })  : assert(txHash != null),
        super(
          type: type,
          date: date,
        );

  @override
  List<Object> get props {
    return super.props + [txHash];
  }
}

/// Represents the notification that is sent to the user after a transaction
/// has been marked as successful.
@immutable
@JsonSerializable(explicitToJson: true)
class TxSuccessfulNotification extends TxNotification {
  const TxSuccessfulNotification({
    @required DateTime date,
    @required String txHash,
  }) : super(
          type: NotificationTypes.TRANSACTION_SUCCESS,
          date: date,
          txHash: txHash,
        );

  factory TxSuccessfulNotification.fromJson(Map<String, dynamic> json) {
    return _$TxSuccessfulNotificationFromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    return _$TxSuccessfulNotificationToJson(this);
  }

  @override
  List<Object> get props {
    return super.props;
  }

  @override
  String toString() {
    return 'TxSuccessfulNotification { '
        'date: $date, '
        'txHash: $txHash '
        '}';
  }
}

/// Represents the notification that is sent to the user when
/// a transaction fails.
@immutable
@JsonSerializable(explicitToJson: true)
class TxFailedNotification extends TxNotification {
  @JsonKey(name: 'error')
  final String error;

  const TxFailedNotification({
    @required DateTime date,
    @required String txHash,
    @required this.error,
  })  : assert(error != null),
        super(
          type: NotificationTypes.TRANSACTION_FAIL,
          date: date,
          txHash: txHash,
        );

  factory TxFailedNotification.fromJson(Map<String, dynamic> json) {
    return _$TxFailedNotificationFromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    return _$TxFailedNotificationToJson(this);
  }

  @override
  List<Object> get props {
    return super.props + [error];
  }
}
