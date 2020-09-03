import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mooncake/ui/ui.dart';
import '../../../helper.dart';

void main() {
  testWidgets('PrimaryLightButton: Displays correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      makeTestableWidget(
        child: PrimaryLightButton(
          child: Text('pineapples'),
          onPressed: () {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(PrimaryLightButton), findsOneWidget);
    expect(find.byType(Text), findsOneWidget);
    expect(find.text('pineapples'), findsOneWidget);
  });
}
