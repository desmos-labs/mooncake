import 'package:pedantic/pedantic.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/sources/sources.dart';
import 'package:test/test.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsMock extends Mock implements SharedPreferences {}

void main() {
  final prefs = SharedPrefsMock();
  final repository = LocalSettingsSourceImpl(
    sharedPreferences: Future.value(prefs),
  );

  test('save works properly', () async {
    when(prefs.setString(any, any)).thenReturn(null);

    final intValue = 1;
    final stringValue = 'value';
    final mapValue = {'first': 'value', 'second': 2};

    await repository.save('first', intValue);
    await repository.save('second', stringValue);
    await repository.save('third', mapValue);

    verify(prefs.setString('first', '1'));
    verify(prefs.setString('second', '\"value\"'));
    verify(prefs.setString('third', '{\"first\":\"value\",\"second\":2}'));
  });

  test('get works properly', () async {
    when(prefs.containsKey('non-existent')).thenReturn(false);
    expect(await repository.get('non-existent'), isNull);

    when(prefs.containsKey('first')).thenReturn(true);
    when(prefs.getString('first')).thenReturn('1');
    expect(await repository.get('first'), equals(1));

    when(prefs.containsKey('second')).thenReturn(true);
    when(prefs.getString('second')).thenReturn('\"value\"');
    expect(await repository.get('second'), equals('value'));

    when(prefs.containsKey('third')).thenReturn(true);
    when(prefs.getString('third'))
        .thenReturn('{\"first\":\"value\",\"second\":2}');
    expect(
      await repository.get('third'),
      equals({'first': 'value', 'second': 2}),
    );
  });

  test('watch listens to selected keys only', () async {
    final txAmountStream = repository.watch(SettingKeys.TX_AMOUNT);
    final backupPermissionStream =
        repository.watch(SettingKeys.BACKUP_POPUP_PERMISSION);

    unawaited(repository.save(SettingKeys.TX_AMOUNT, 1));
    unawaited(repository.save(SettingKeys.BACKUP_POPUP_PERMISSION, false));
    unawaited(repository.save(SettingKeys.TX_AMOUNT, 2));

    await expectLater(
      txAmountStream,
      emitsInOrder([
        1,
        2,
      ]),
    );

    unawaited(repository.save(SettingKeys.TX_AMOUNT, 1));
    unawaited(repository.save(SettingKeys.BACKUP_POPUP_PERMISSION, false));

    await expectLater(
      backupPermissionStream,
      emitsInOrder([
        false,
      ]),
    );
  });
}
