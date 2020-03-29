import 'package:equatable/equatable.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';

part 'reaction.g.dart';

/// Represents a reaction for a post that has been inserted by a specific user.
@immutable
@JsonSerializable(explicitToJson: true, ignoreUnannotated: true)
class Reaction extends Equatable {
  @JsonKey(name: "user")
  final User user;

  /// Represents the
  @JsonKey(name: "value")
  final String code;

  /// Represents the Unicode character that identifies the emoji.
  final String rune;

  /// Tells whether or not this reaction represents a like.
  bool get isLike => code == Constants.LIKE_REACTION;

  Reaction({
    @required this.user,
    @required String code,
  })  : assert(user != null),
        assert(code != null),
        this.code = EmojiUtils.getEmojiCode(code),
        this.rune = EmojiUtils.getEmojiRune(code);

  factory Reaction.fromJson(Map<String, dynamic> json) =>
      _$ReactionFromJson(json);

  @override
  List<Object> get props => [this.user, this.code];

  /// Allows to create a copy of this [Reaction] having either [user] or
  /// [code] changed.
  Reaction copyWith({
    User user,
    String code,
  }) {
    return Reaction(
      user: user ?? this.user,
      code: code ?? this.code,
    );
  }

  Map<String, dynamic> toJson() => _$ReactionToJson(this);
}
