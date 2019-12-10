import 'package:dwitter/sources/sources.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post_json.g.dart';

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

  @JsonKey(name: "external_reference")
  final String externalReference;

  @JsonKey(name: "owner")
  final String owner;

  @JsonKey(name: "likes")
  final List<LikeJson> likes;

  @JsonKey(name: "children")
  final List<String> commentsIds;

  PostJson({
    this.id,
    this.parentId,
    this.message,
    this.created,
    this.lastEdited,
    this.allowsComments,
    this.externalReference,
    this.owner,
    this.likes,
    this.commentsIds,
  })  : assert(id != null),
        assert(parentId != null),
        assert(message != null),
        assert(created != null),
        assert(lastEdited != null),
        assert(allowsComments != null),
        assert(externalReference != null),
        assert(owner != null),
        assert(likes != null),
        assert(commentsIds != null);

  factory PostJson.fromJson(Map<String, dynamic> json) =>
      _$PostJsonFromJson(json);

  Map<String, dynamic> toJson() => _$PostJsonToJson(this);
}
