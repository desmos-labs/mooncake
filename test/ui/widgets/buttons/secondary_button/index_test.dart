import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mooncake/ui/ui.dart';
import '../../../helper.dart';

void main() {
  testWidgets('SecondaryButton: Displays correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      makeTestableWidget(
        child: SecondaryLightButton(
          child: Text('pineapples'),
          onPressed: () {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(FlatButton), findsOneWidget);
    expect(find.byType(Text), findsOneWidget);
    expect(find.text('pineapples'), findsOneWidget);
    expect(tester.widget<FlatButton>(find.byType(FlatButton)).color,
        Color(0xFF6D4DDB));
  });
}
