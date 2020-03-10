import 'package:equatable/equatable.dart';
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

  @JsonKey(name: "value")
  final String value;

  /// Tells whether or not this reaction represents a like.
  bool get isLike => value == Constants.LIKE_REACTION;

  Reaction({
    @required this.user,
    this.value,
  })  : assert(user != null),
        assert(value != null);

  @override
  List<Object> get props => [this.user, this.value];

  factory Reaction.fromJson(Map<String, dynamic> json) =>
      _$ReactionFromJson(json);

  /// Allows to create a copy of this [Reaction] having either [user] or
  /// [value] changed.
  Reaction copyWith({
    User user,
    String value,
  }) {
    return Reaction(
      user: user ?? this.user,
      value: value ?? this.value,
    );
  }

  Map<String, dynamic> toJson() => _$ReactionToJson(this);
}
