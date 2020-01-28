import 'package:mooncake/entities/entities.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'msg_add_post_reaction.g.dart';

/// Represents the message that must be used when add a reaction
/// to a post.
@JsonSerializable()
class MsgAddPostReaction implements StdMsg {
  @JsonKey(name: "post_id")
  final String postId;

  @JsonKey(name: "value")
  final String reaction;

  @JsonKey(name: "user")
  final String user;

  MsgAddPostReaction({
    @required this.postId,
    @required this.reaction,
    @required this.user,
  })  : assert(postId != null),
        assert(reaction != null),
        assert(user != null);

  @override
  List<Object> get props => [postId, reaction, user];

  @override
  Map<String, dynamic> toJson() => _$MsgAddPostReactionToJson(this);
}
