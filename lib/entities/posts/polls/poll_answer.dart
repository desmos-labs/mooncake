import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';

part 'poll_answer.g.dart';

/// Represents the responses of a user that has been added to a poll.
@immutable
@JsonSerializable(explicitToJson: true)
class PollAnswer extends Equatable {
  @JsonKey(name: "answers")
  final List<int> answers;

  @JsonKey(name: "user")
  final User user;

  PollAnswer({
    @required this.answers,
    @required this.user,
  })  : assert(answers != null),
        assert(user != null);

  factory PollAnswer.fromJson(Map<String, dynamic> json) {
    return _$PollAnswerFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$PollAnswerToJson(this);
  }

  PollAnswer copyWith({
    List<int> answers,
    User user,
  }) {
    return PollAnswer(
      answers: answers ?? this.answers,
      user: user ?? this.user,
    );
  }

  @override
  List<Object> get props {
    return [answers, user];
  }
}
