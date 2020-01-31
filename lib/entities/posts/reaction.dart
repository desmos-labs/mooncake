import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'reaction.g.dart';

/// Represents a reaction for a post that has been inserted by a specific user.
@immutable
@JsonSerializable(explicitToJson: true)
class Reaction extends Equatable {
  @JsonKey(name: "owner")
  final String owner;

  @JsonKey(name: "value")
  final String value;

  Reaction({@required this.owner, this.value})
      : assert(owner != null),
        assert(value != null);

  @override
  List<Object> get props => [this.owner, this.value];

  factory Reaction.fromJson(Map<String, dynamic> json) =>
      _$ReactionFromJson(json);

  Map<String, dynamic> toJson() => _$ReactionToJson(this);
}
