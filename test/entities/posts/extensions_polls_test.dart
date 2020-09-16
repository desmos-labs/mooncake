import 'package:flutter_test/flutter_test.dart';
import 'package:mooncake/entities/entities.dart';

void main() {
  final poll = PostPoll(
    question: 'Do you like muffins?',
    endDate: '2020-05-01T21:00:00Z',
    options: [
      PollOption(id: 1, text: 'Yes'),
      PollOption(id: 2, text: 'No'),
    ],
    allowsMultipleAnswers: false,
    allowsAnswerEdits: false,
  );

  group('containsAnswerFrom', () {
    test('returns false if answer does not exist', () {
      final pollWithAnswers = poll.copyWith(userAnswers: [
        PollAnswer(user: User.fromAddress('address'), answer: 1)
      ]);
      expect(pollWithAnswers.containsAnswerFrom('non-existing', 1), isFalse);
      expect(pollWithAnswers.containsAnswerFrom('address', 2), isFalse);
    });

    test('returns true if answer exists', () {
      final pollWithAnswers = poll.copyWith(userAnswers: [
        PollAnswer(user: User.fromAddress('address'), answer: 1)
      ]);
      expect(pollWithAnswers.containsAnswerFrom('address', 1), isTrue);
    });
  });
}
