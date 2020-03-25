
import 'package:flutter_emoji/flutter_emoji.dart';

/// Given the [unicode] of an emoji, returns the `:code:` representation
/// of such emoji.
String getEmojiCode(String unicode) {
  final parser = EmojiParser();
  return parser.unemojify(unicode);
}

String getEmojiRune(String code) {
  final parser = EmojiParser();
  return parser.emojify(code);
}
