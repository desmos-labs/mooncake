import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mooncake/ui/widgets/mnemonic_visualizer/widgets/export.dart';
import '../../../../helper.dart';

void main() {
  testWidgets('MnemonicItem: Displays correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      makeTestableWidget(
        child: MnemonicItem(index: 0, word: 'apples'),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(Row), findsOneWidget);
    expect(find.text('apples'), findsOneWidget);
    expect(
      tester.widget<Text>(find.byType(Text).last).textAlign,
      TextAlign.center,
    );
  });
}
