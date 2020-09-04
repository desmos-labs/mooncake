import 'package:flutter_test/flutter_test.dart';
import 'package:mooncake/entities/entities.dart';

void main() {
  group('TxSuccessfulNotification', () {
    test('toJson and fromJson', () {
      final notification = TxSuccessfulNotification(
        date: DateTime.now(),
        txHash: 'hash',
      );
      final json = notification.asJson();
      final fromJson = NotificationData.fromJson(json);
      expect(fromJson, equals(notification));
    });
  });

  group('TxFailedNotification', () {
    test('toJson and fromJson', () {
      final notification = TxFailedNotification(
        date: DateTime.now(),
        txHash: 'hash',
        error: 'This is the transaction error',
      );
      final json = notification.asJson();
      final fromJson = NotificationData.fromJson(json);
      expect(fromJson, equals(notification));
    });
  });
}
