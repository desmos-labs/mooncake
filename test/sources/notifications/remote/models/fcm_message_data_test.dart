import 'package:flutter_test/flutter_test.dart';
import 'package:mooncake/sources/notifications/remote/models/fcm_message_data.dart';

void main() {
  group('FcmMessage', () {
    group('fromJson', () {
      test('works properly with iOS notification', () {
        final data = {
          'from': '/topics/desmos1krtha42rdmmu3y580m5mfmvlczwr6vt292g7xz',
          'post_reaction_owner':
              'desmos14dm0zdemeymhayucp7gchuus3k5m344f3v8nln',
          'post_id':
              '07bb35675ff8f7190132d9f92623155b2a1819d13ebf71f7fc0fa0559eda9b19',
          'notification': {
            'android_channel_id': 'mooncake_posts',
            'body':
                'desmos14dm0zdemeymhayucp7gchuus3k5m344f3v8nln added a new reaction to your post: 😇',
            'title': 'Someone added a new reaction to one of your posts 🎉',
            'e': '1'
          },
          'action': 'open_post',
          'collapse_key': 'com.forbole.mooncake',
          'post_reaction_value': '😇',
          'type': 'reaction',
          'post_reaction_shortcode': ':innocent:',
          'click_action': 'FLUTTER_NOTIFICATION_CLICK'
        };

        final message = FcmMessage.fromJson(data);
        expect(message.data, isNotNull);
        expect(
          message.data['post_id'],
          '07bb35675ff8f7190132d9f92623155b2a1819d13ebf71f7fc0fa0559eda9b19',
        );
        expect(
          message.data['post_reaction_owner'],
          'desmos14dm0zdemeymhayucp7gchuus3k5m344f3v8nln',
        );
        expect(message.data['action'], 'open_post');
        expect(message.data['post_reaction_value'], '😇');
        expect(message.data['post_reaction_shortcode'], ':innocent:');
      });
    });
  });
}
