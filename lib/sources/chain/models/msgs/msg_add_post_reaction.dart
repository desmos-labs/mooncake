import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';

part 'msg_add_post_reaction.g.dart';

/// Represents the message that must be used when add a reaction
/// to a post.
@immutable
@reflector
@JsonSerializable(explicitToJson: true)
class MsgAddPostReaction extends StdMsg {
  @JsonKey(name: 'post_id')
  final String postId;

  @JsonKey(name: 'reaction')
  final String reaction;

  @JsonKey(name: 'user')
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
  Map<String, dynamic> asJson() => _$MsgAddPostReactionToJson(this);

  factory MsgAddPostReaction.fromJson(Map<String, dynamic> json) =>
      _$MsgAddPostReactionFromJson(json);

  @override
  Exception validate() {
    if (postId.isEmpty || reaction.isEmpty || user.isEmpty) {
      return Exception('Malformed MsgAddPostReaction');
    }

    return null;
  }
}
