import 'package:mooncake/ui/ui.dart';

/// Represents a generic event related to the poll of a post.
abstract class PostInputPollEvent extends PostInputEvent {}

/// Tells the Bloc that a poll needs to be added to the post.
class CreatePoll extends PostInputPollEvent {}

/// Tells the Bloc that the poll question needs to be updated.
class UpdatePollQuestion extends PostInputPollEvent {
  final String question;

  UpdatePollQuestion(this.question);

  @override
  List<Object> get props => [question];
}

/// Tells the Bloc that the question at the given index should be updated.
class UpdatePollOption extends PostInputPollEvent {
  final int index;
  final String option;

  UpdatePollOption(this.index, this.option);

  @override
  List<Object> get props => [index, option];
}

/// Tells the Bloc that the option at the given index should be deleted.
class DeletePollOption extends PostInputPollEvent {
  final int index;

  DeletePollOption(this.index);

  @override
  List<Object> get props => [index];
}

/// Tells the Bloc that a new option should be added to the poll.
class AddPollOption extends PostInputPollEvent {}

/// Tells the Bloc that the end date of the poll should be change to the one
/// given.
class ChangePollDate extends PostInputPollEvent {
  final DateTime endDate;

  ChangePollDate(this.endDate);

  @override
  List<Object> get props => [endDate];
}
