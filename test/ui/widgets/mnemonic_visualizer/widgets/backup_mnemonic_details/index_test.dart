import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mooncake/ui/widgets/mnemonic_visualizer/widgets/export.dart';
import '../../../../helper.dart';

void main() {
  testWidgets('BackupMnemonicDetails: Displays correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      makeTestableWidget(
        child: BackupMnemonicDetails(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(RichText), findsOneWidget);
    expect(
      tester.widget<Container>(find.byType(Container)).margin,
      EdgeInsets.only(bottom: 20),
    );
  });
}
