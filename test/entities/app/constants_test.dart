import 'package:test/test.dart';
import 'package:mooncake/entities/entities.dart';

void main() {
  test('constants values', () {
    expect(Constants.EXPLORER, equals('https://morpheus.desmos.network'));
    expect(Constants.SUBSPACE,
        '2bdf5932925584b9a86470bea60adce69041608a447f84a3317723aa5678ec88');
    expect(Constants.FEE_TOKEN, equals('udaric'));
    expect(Constants.LIKE_REACTION, equals('❤'));
  });
}
