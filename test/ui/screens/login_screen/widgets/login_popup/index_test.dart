import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mooncake/ui/ui.dart';
import '../../../../helper.dart';
import 'package:mooncake/ui/screens/login_screen/widgets/export.dart';

void main() {
  testWidgets('LoginPopup: Displays correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      makeTestableWidget(
        child: LoginPopup(
          content: Text('content'),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byType(GenericPopup), findsOneWidget);
    expect(find.byType(CustomPaint), findsWidgets);
    expect(find.text('content'), findsOneWidget);
  });
}
