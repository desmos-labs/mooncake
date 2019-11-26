import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'like.g.dart';

/// Represents a like for a post that has been inserted by a specific user.
@JsonSerializable(explicitToJson: true)
class Like extends Equatable {
  @JsonKey(name: "owner")
  final String owner;

  Like(this.owner) : assert(owner != null);

  @override
  List<Object> get props {
    return [this.owner];
  }

  factory Like.fromJson(Map<String, dynamic> json) => _$LikeFromJson(json);

  Map<String, dynamic> toJson() => _$LikeToJson(this);
}
