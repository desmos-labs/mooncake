// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_notifications.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TxSuccessfulNotification _$TxSuccessfulNotificationFromJson(
    Map<String, dynamic> json) {
  return TxSuccessfulNotification(
    date: NotificationData.dateFromJson(json['date'] as String),
    txHash: json['tx_hash'] as String,
  );
}

Map<String, dynamic> _$TxSuccessfulNotificationToJson(
        TxSuccessfulNotification instance) =>
    <String, dynamic>{
      'date': NotificationData.dateToJson(instance.date),
      'tx_hash': instance.txHash,
    };

TxFailedNotification _$TxFailedNotificationFromJson(Map<String, dynamic> json) {
  return TxFailedNotification(
    date: NotificationData.dateFromJson(json['date'] as String),
    txHash: json['tx_hash'] as String,
    error: json['error'] as String,
  );
}

Map<String, dynamic> _$TxFailedNotificationToJson(
        TxFailedNotification instance) =>
    <String, dynamic>{
      'date': NotificationData.dateToJson(instance.date),
      'tx_hash': instance.txHash,
      'error': instance.error,
    };
