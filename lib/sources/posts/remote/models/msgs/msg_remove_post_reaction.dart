import 'package:mooncake/entities/entities.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'msg_remove_post_reaction.g.dart';

/// Represents the message that must be used
/// when removing a reaction from a post.
@JsonSerializable()
class MsgRemovePostReaction extends StdMsg {
  @JsonKey(name: "post_id")
  final String postId;

  @JsonKey(name: "reaction")
  final String reaction;

  @JsonKey(name: "user")
  final String user;

  MsgRemovePostReaction({
    @required this.postId,
    @required this.reaction,
    @required this.user,
  })  : assert(postId != null),
        assert(reaction != null),
        assert(user != null);

  @override
  List<Object> get props => [postId, reaction, user];

  @override
  Map<String, dynamic> toJson() => _$MsgRemovePostReactionToJson(this);

  @override
  Exception validate() {
    if (postId.isEmpty || reaction.isEmpty || user.isEmpty) {
      return Exception("Malformed MsgRemovePostReaction");
    }

    return null;
  }
}
