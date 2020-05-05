import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mooncake/entities/entities.dart';

part 'post_poll.g.dart';

@immutable
@JsonSerializable(explicitToJson: true)
class PostPoll extends Equatable {
  final String question;
  final DateTime endDate;
  final List<PollOption> options;

  PostPoll({
    @required this.question,
    @required this.endDate,
    @required this.options,
  })  : assert(question != null),
        assert(endDate != null),
        assert(options != null);

  factory PostPoll.fromJson(Map<String, dynamic> json) {
    return _$PostPollFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$PostPollToJson(this);
  }

  @override
  List<Object> get props => [question, endDate, options];

  @override
  String toString() {
    return 'PostPoll {'
        'question: $question, '
        'endDate: $endDate, '
        'options: $options, '
        '}';
  }
}
