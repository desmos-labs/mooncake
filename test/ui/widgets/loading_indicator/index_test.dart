import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mooncake/ui/ui.dart';

void main() {
  testWidgets('LoadingIndicator: Displays correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      LoadingIndicator(),
    );
    await tester.pump(const Duration(seconds: 3));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(
      tester
          .widget<CircularProgressIndicator>(
              find.byType(CircularProgressIndicator))
          .strokeWidth,
      2,
    );
  });
}
