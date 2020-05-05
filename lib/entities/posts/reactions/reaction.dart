import 'package:equatable/equatable.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';

part 'reaction.g.dart';

/// Represents a reaction for a post that has been inserted by a specific user.
@immutable
@JsonSerializable(explicitToJson: true)
class Reaction extends Equatable {
  @JsonKey(name: "user")
  final User user;

  /// Represents the Unicode character that identifies the emoji.
  @JsonKey(name: "value")
  final String value;

  /// Represents the shortcode that identifies the emoji.
  final String code;

  /// Tells whether or not this reaction represents a like.
  bool get isLike => value.replaceAll("️", "") == Constants.LIKE_REACTION;

  Reaction({
    @required this.user,
    @required String value,
  })  : assert(user != null),
        assert(value != null),
        this.value = EmojiUtils.getEmojiRune(value),
        this.code = EmojiUtils.getEmojiCode(value);

  factory Reaction.fromJson(Map<String, dynamic> json) =>
      _$ReactionFromJson(json);

  @override
  List<Object> get props => [this.user, this.value];

  Map<String, dynamic> toJson() => _$ReactionToJson(this);

  @override
  String toString() {
    return 'Reaction { value: $value }';
  }
}
