import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';

part 'poll_answer.g.dart';

/// Represents the responses of a user that has been added to a poll.
@immutable
@JsonSerializable(explicitToJson: true)
class PollAnswer extends Equatable {
  /// Id of the answer that the user has selected.
  /// This id refers to one of the [PostPoll.options]'s `id` field.
  @JsonKey(name: 'answer')
  final int answer;

  /// User that has created this answer.
  @JsonKey(name: 'user')
  final User user;

  const PollAnswer({
    @required this.answer,
    @required this.user,
  })  : assert(answer != null),
        assert(user != null);

  factory PollAnswer.fromJson(Map<String, dynamic> json) {
    return _$PollAnswerFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$PollAnswerToJson(this);
  }

  PollAnswer copyWith({
    int answer,
    User user,
  }) {
    return PollAnswer(
      answer: answer ?? this.answer,
      user: user ?? this.user,
    );
  }

  @override
  List<Object> get props {
    return [answer, user.address];
  }
}
