import 'package:dwitter/entities/entities.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('getPostIdByReference returns correct results', () {
    expect(getPostIdByReference(null), null);
    expect(getPostIdByReference(""), null);
    expect(getPostIdByReference("   "), null);
    expect(getPostIdByReference("twitter-"), null);

    expect(getPostIdByReference("dwitter-10"), "10");
  });
}
