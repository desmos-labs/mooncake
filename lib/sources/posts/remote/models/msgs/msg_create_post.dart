import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';

part 'msg_create_post.g.dart';

/// Represents the message that should be used when creating a new post or
/// comment.
@immutable
@reflector
@JsonSerializable(explicitToJson: true)
class MsgCreatePost extends StdMsg {
  @JsonKey(name: "parent_id")
  final String parentId;

  @JsonKey(name: "message")
  final String message;

  @JsonKey(name: "allows_comments")
  final bool allowsComments;

  @JsonKey(name: "subspace")
  final String subspace;

  @JsonKey(name: "optional_data", includeIfNull: false)
  final Map<String, String> optionalData;

  @JsonKey(name: "creator")
  final String creator;

  @JsonKey(name: "creation_date")
  final String creationDate;

  @JsonKey(name: "medias", includeIfNull: false)
  final List<PostMedia> medias;

  MsgCreatePost({
    @required this.parentId,
    @required this.message,
    @required this.allowsComments,
    @required this.subspace,
    @required this.optionalData,
    @required this.creator,
    @required this.creationDate,
    @required this.medias,
  })  : assert(parentId != null),
        assert(message != null),
        assert(allowsComments != null),
        assert(subspace != null),
        assert(creator != null),
        assert(creationDate != null);

  @override
  List<Object> get props => [
        parentId,
        message,
        allowsComments,
        subspace,
        optionalData,
        creator,
        creationDate,
        medias,
      ];

  @override
  Map<String, dynamic> asJson() => _$MsgCreatePostToJson(this);

  factory MsgCreatePost.fromJson(Map<String, dynamic> json) =>
      _$MsgCreatePostFromJson(json);

  @override
  Exception validate() {
    if (parentId.isEmpty ||
        message.isEmpty ||
        subspace.isEmpty ||
        creator.isEmpty ||
        creationDate.isEmpty) {
      return Exception("Malformed MsgCreatePost");
    }

    return null;
  }
}
