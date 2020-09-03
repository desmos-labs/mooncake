import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mooncake/ui/ui.dart';
import '../../helper.dart';

void main() {
  testWidgets('GenericPopup: Displays correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      makeTestableWidget(
        child: GenericPopup(
          content: Text('strawberries'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(Padding), findsWidgets);
    expect(find.byType(GestureDetector), findsOneWidget);
    expect(find.text('strawberries'), findsOneWidget);
    expect(
      tester
          .widget<Material>(
            find.descendant(
              of: find.byType(GestureDetector),
              matching: find.byType(Material),
            ),
          )
          .elevation,
      6,
    );
  });
}
