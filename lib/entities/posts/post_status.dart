import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'post_status.g.dart';

/// Represents the status of a post.
@JsonSerializable(explicitToJson: true)
class PostStatus extends Equatable {
  @JsonKey(name: "value")
  final PostStatusValue value;
  final String error;

  const PostStatus({
    @required this.value,
    this.error,
  }) : assert(value != null);

  @override
  List<Object> get props => [value, error];

  factory PostStatus.fromJson(Map<String, dynamic> json) =>
      _$PostStatusFromJson(json);

  Map<String, dynamic> toJson() => _$PostStatusToJson(this);
}

/// Contains the possible values of a post status.
enum PostStatusValue {
  @JsonValue("to_be_synced")
  TO_BE_SYNCED,
  @JsonValue("syncing")
  SYNCING,
  @JsonValue("synced")
  SYNCED,
  @JsonValue("errored")
  ERRORED
}
