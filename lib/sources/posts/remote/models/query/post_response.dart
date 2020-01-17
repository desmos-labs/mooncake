import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/sources/sources.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post_response.g.dart';

@JsonSerializable(explicitToJson: true)
class PostJson {
  @JsonKey(name: "id")
  final String id;

  @JsonKey(name: "parent_id")
  final String parentId;

  @JsonKey(name: "message")
  final String message;

  @JsonKey(name: "created")
  final String created;

  @JsonKey(name: "last_edited")
  final String lastEdited;

  @JsonKey(name: "allows_comments")
  final bool allowsComments;

  @JsonKey(name: "subspace")
  final String subspace;

  @JsonKey(name: "creator")
  final String creator;

  @JsonKey(name: "reactions")
  final List<Reaction> reactions;

  @JsonKey(name: "children")
  final List<String> commentsIds;

  @JsonKey(name: "optional_data")
  final Map<String, String> optionalData;

  PostJson({
    this.id,
    this.parentId,
    this.message,
    this.created,
    this.lastEdited,
    this.allowsComments,
    this.subspace,
    this.creator,
    this.reactions,
    this.commentsIds,
    this.optionalData,
  })  : assert(id != null),
        assert(parentId != null),
        assert(message != null),
        assert(created != null),
        assert(lastEdited != null),
        assert(allowsComments != null),
        assert(subspace != null),
        assert(creator != null),
        assert(reactions != null),
        assert(commentsIds != null);

  factory PostJson.fromJson(Map<String, dynamic> json) =>
      _$PostJsonFromJson(json);

  Map<String, dynamic> toJson() => _$PostJsonToJson(this);
}
