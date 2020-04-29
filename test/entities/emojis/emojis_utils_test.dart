import 'package:test/test.dart';
import 'package:mooncake/entities/emojis/emoji_utils.dart';

void main() {
  test('getEmojiCode', () {
    expect(EmojiUtils.getEmojiCode("🎉"), equals(":tada:"));
    expect(EmojiUtils.getEmojiCode("🍉"), equals(":watermelon:"));
    expect(EmojiUtils.getEmojiCode("❤️️"), equals(":heart:"));
    expect(EmojiUtils.getEmojiCode("👍"), equals(":thumbsup:"));
  });

  test('getEmojiRune', () {
    expect(EmojiUtils.getEmojiRune(":tada:"), equals("🎉"));
    expect(EmojiUtils.getEmojiRune(":watermelon:"), equals("🍉"));
    expect(EmojiUtils.getEmojiRune(":heart:️"), equals("❤️️"));
    expect(EmojiUtils.getEmojiRune(":thumbsup:"), equals("👍"));
  });
}
