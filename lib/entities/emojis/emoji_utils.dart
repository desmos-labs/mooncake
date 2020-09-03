import 'package:flutter_emoji/flutter_emoji.dart';

class EmojiUtils {
  /// Given the [unicode] of an emoji, returns the `:code:` representation
  /// of such emoji.
  static String getEmojiCode(String unicode) {
    final parser = EmojiParser();
    return parser.unemojify(unicode);
  }

  /// Given an emoji [code], returns the corresponding rune that identifies
  /// such emoji.
  static String getEmojiRune(String code) {
    final parser = EmojiParser();
    return parser.emojify(code).replaceAll('️', '');
  }
}
