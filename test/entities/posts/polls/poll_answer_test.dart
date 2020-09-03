import 'package:flutter_test/flutter_test.dart';
import 'package:mooncake/entities/entities.dart';

void main() {
  final answer = PollAnswer(user: User.fromAddress('address'), answer: 1);

  test('toJson and fromJson', () {
    final json = answer.toJson();
    final fromJson = PollAnswer.fromJson(json);
    expect(fromJson, equals(answer));
  });
}
