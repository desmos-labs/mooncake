import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mooncake/ui/ui.dart';
import '../../helper.dart';
import 'package:mooncake/ui/widgets/mnemonic_visualizer/widgets/export.dart';

void main() {
  testWidgets('MnemonicVisualizer: Displays export correctly',
      (WidgetTester tester) async {
    var mnemonic = List<String>.filled(24, 'apples');
    await tester.pumpWidget(
      makeTestableWidget(
          child: Container(
        child: MnemonicVisualizer(
          mnemonic: mnemonic,
        ),
      )),
    );

    await tester.pumpAndSettle();

    expect(find.byType(BackupMnemonicButton), findsNothing);
    expect(find.byType(BackupMnemonicDetails), findsNothing);
    expect(find.byType(ExportMnemonicButton), findsOneWidget);
  });

  testWidgets('MnemonicVisualizer: Displays backup correctly',
      (WidgetTester tester) async {
    var mnemonic = List<String>.filled(24, 'apples');
    await tester.pumpWidget(
      makeTestableWidget(
          child: Container(
        child: MnemonicVisualizer(
          mnemonic: mnemonic,
          backupPhrase: true,
          allowExport: false,
        ),
      )),
    );

    await tester.pumpAndSettle();

    expect(find.byType(BackupMnemonicButton), findsOneWidget);
    expect(find.byType(BackupMnemonicDetails), findsOneWidget);
    expect(find.byType(ExportMnemonicButton), findsNothing);
  });
}
