import 'package:flutter_test/flutter_test.dart';
import 'package:mooncake/entities/entities.dart';

void main() {
  final option = PollOption(text: 'This is a poll option', id: 1);

  test('toJson and fromJson', () {
    final json = option.toJson();
    final fromJson = PollOption.fromJson(json);
    expect(fromJson, equals(option));
  });
}
