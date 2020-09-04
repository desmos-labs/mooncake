import 'package:flutter_test/flutter_test.dart';
import 'package:mooncake/entities/entities.dart';

void main() {
  group('PostCommentNotification', () {
    test('toJson and fromJson', () {
      final notification = PostCommentNotification(
        postId: '1',
        user: User.fromAddress('address'),
        comment: 'This is my comment',
        date: DateTime.now(),
        title: 'Notification title',
        body: 'Notification body',
      );
      final json = notification.asJson();
      final fromJson = NotificationData.fromJson(json);
      expect(fromJson, equals(notification));
    });
  });

  group('PostMentionNotification', () {
    test('toJson and fromJson', () {
      final notification = PostMentionNotification(
        postId: '1',
        user: User.fromAddress('address'),
        text: 'This is the mention',
        date: DateTime.now(),
        title: 'Notification title',
        body: 'Notification body',
      );
      final json = notification.asJson();
      final fromJson = NotificationData.fromJson(json);
      expect(fromJson, equals(notification));
    });
  });

  group('PostTagNotification', () {
    test('toJson and fromJson', () {
      final notification = PostTagNotification(
        postId: '1',
        user: User.fromAddress('address'),
        date: DateTime.now(),
        title: 'Notification title',
        body: 'Notification body',
      );
      final json = notification.asJson();
      final fromJson = NotificationData.fromJson(json);
      expect(fromJson, equals(notification));
    });
  });

  group('PostReactionNotification', () {
    test('toJson and fromJson', () {
      final notification = PostReactionNotification(
        postId: '1',
        user: User.fromAddress('address'),
        date: DateTime.now(),
        title: 'Notification title',
        body: 'Notification body',
        reaction: 'This is my reaction',
      );
      final json = notification.asJson();
      final fromJson = NotificationData.fromJson(json);
      expect(fromJson, equals(notification));
    });
  });

  group('PostLikeNotification', () {
    test('toJson and fromJson', () {
      final notification = PostLikeNotification(
        postId: '1',
        user: User.fromAddress('address'),
        date: DateTime.now(),
        title: 'Notification title',
        body: 'Notification body',
      );
      final json = notification.asJson();
      final fromJson = NotificationData.fromJson(json);
      expect(fromJson, equals(notification));
    });
  });
}
