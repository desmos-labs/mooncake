import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mooncake/ui/ui.dart';
import '../../../helper.dart';

void main() {
  testWidgets('SecondaryDarkButton: Displays correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      makeTestableWidget(
        child: SecondaryDarkButton(
          child: Text('melons'),
          onPressed: () {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(FlatButton), findsOneWidget);
    expect(find.byType(Text), findsOneWidget);
    expect(find.text('melons'), findsOneWidget);
    expect(
      tester.widget<FlatButton>(find.byType(FlatButton)).textColor,
      Color(0xFF6D4DDB),
    );
  });

  testWidgets('SecondaryDarkButton: Displays correctly Dark',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      makeTestableWidget(
        theme: 'dark',
        child: SecondaryDarkButton(
          child: Text('melons'),
          onPressed: () {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      tester.widget<FlatButton>(find.byType(FlatButton)).textColor,
      Color(0xFFA990FF),
    );
  });
}
