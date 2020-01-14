import 'package:mooncake/entities/entities.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'msg_create_post.g.dart';

@JsonSerializable()
class MsgCreatePost implements StdMsg {
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

  MsgCreatePost({
    @required this.parentId,
    @required this.message,
    @required this.allowsComments,
    @required this.subspace,
    @required this.optionalData,
    @required this.creator,
    @required this.creationDate,
  })  : assert(parentId != null),
        assert(message != null),
        assert(allowsComments != null),
        assert(subspace != null),
        assert(creator != null),
        assert(creationDate != null);

  @override
  Map<String, dynamic> toJson() => _$MsgCreatePostToJson(this);
}
