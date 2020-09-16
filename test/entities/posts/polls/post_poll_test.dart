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

  test('endDateTime returns correct value', () {
    final date = poll.endDateTime;
    expect(date.year, equals(2020));
    expect(date.month, equals(05));
    expect(date.day, equals(01));
  });

  group('isValid', () {
    test('returns true with valid poll', () {
      expect(poll.isValid, isTrue);
    });

    test('returns false with empty poll', () {
      expect(PostPoll.empty().isValid, isFalse);
    });
  });

  test('toJson and fromJson', () {
    final json = poll.toJson();
    final fromJson = PostPoll.fromJson(json);
    expect(fromJson, equals(poll));
  });
}
