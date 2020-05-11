import 'package:mooncake/entities/entities.dart';

extension PollsExt on PostPoll {
  bool containsAnswerFrom(String address, int value) {
    return this.userAnswers.where((element) {
      return element.user.address == address && element.answer == value;
    }).isNotEmpty;
  }
}
