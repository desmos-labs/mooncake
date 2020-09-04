import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';

part 'msg_answer_poll.g.dart';

/// Represents the message used to send a new answer to a post poll.
@immutable
@reflector
@JsonSerializable(explicitToJson: true)
class MsgAnswerPoll extends StdMsg {
  @JsonKey(name: 'post_id')
  final String postId;

  @JsonKey(name: 'answers')
  final List<String> answers;

  @JsonKey(name: 'answerer')
  final String user;

  MsgAnswerPoll({
    @required this.postId,
    @required this.answers,
    @required this.user,
  })  : assert(postId != null),
        assert(answers != null && answers.isNotEmpty),
        assert(user != null);

  factory MsgAnswerPoll.fromJson(Map<String, dynamic> json) {
    return _$MsgAnswerPollFromJson(json);
  }

  @override
  Map<String, dynamic> asJson() {
    return _$MsgAnswerPollToJson(this);
  }

  @override
  List<Object> get props {
    return [postId, answers, user];
  }

  @override
  Exception validate() {
    if (postId == '') {
      return Exception('post id cannot be empty');
    }

    if (user.trim().isEmpty) {
      return Exception('user cannot be empty');
    }

    return null;
  }
}
