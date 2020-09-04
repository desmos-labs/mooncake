import 'package:mooncake/entities/entities.dart';

/// Defines a set of useful extensions on the [PostPoll] type.
extension PollsExt on PostPoll {
  /// Tells whether `this` [PostPoll] contains an answer from the user
  /// having the given [address] with the given [value].
  bool containsAnswerFrom(String address, int value) {
    return userAnswers.where((element) {
      return element.user.address == address && element.answer == value;
    }).isNotEmpty;
  }
}
