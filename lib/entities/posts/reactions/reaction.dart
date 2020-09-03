import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';

part 'reaction.g.dart';

/// Represents a reaction for a post that has been inserted by a specific user.
@immutable
@JsonSerializable(explicitToJson: true)
class Reaction extends Equatable {
  @JsonKey(name: 'user')
  final User user;

  /// Represents the Unicode character that identifies the emoji.
  @JsonKey(name: 'value')
  final String value;

  /// Represents the shortcode that identifies the emoji.
  @JsonKey(name: 'short_code', nullable: true)
  final String code;

  /// Tells whether or not this reaction represents a like.
  bool get isLike => value.replaceAll('️', '') == Constants.LIKE_REACTION;

  const Reaction({
    @required this.user,
    @required this.value,
    @required this.code,
  })  : assert(user != null),
        assert(value != null);

  factory Reaction.fromValue(String value, User user) {
    return Reaction(
      user: user,
      value: EmojiUtils.getEmojiRune(value),
      code: EmojiUtils.getEmojiCode(value),
    );
  }

  factory Reaction.fromJson(Map<String, dynamic> json) {
    final react = _$ReactionFromJson(json);
    return react.code != null
        ? react
        : react.copyWith(
            code: EmojiUtils.getEmojiCode(react.value),
          );
  }

  Map<String, dynamic> toJson() {
    return _$ReactionToJson(this);
  }

  Reaction copyWith({
    String code,
    String value,
    User user,
  }) {
    return Reaction(
      code: code ?? this.code,
      value: value ?? this.value,
      user: user ?? this.user,
    );
  }

  @override
  List<Object> get props {
    return [user.address, value, code];
  }

  @override
  String toString() {
    return 'Reaction { value: $value, code: $code, user: ${user.address} }';
  }
}
