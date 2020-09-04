import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mooncake/ui/ui.dart';
import '../../helper.dart';

void main() {
  testWidgets('PasswordStrengthIndicator: Displays correctly',
      (WidgetTester tester) async {
    var security = PasswordSecurity.LOW;
    StateSetter setStateController;

    await tester.pumpWidget(
      makeTestableWidget(
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            setStateController = setState;

            return Container(
              child: PasswordStrengthIndicator(security: security),
            );
          },
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byType(Expanded), findsNWidgets(4));
    expect(find.text('passwordSecurityLow'), findsOneWidget);
    expect(
      tester.widget<Text>(find.byType(Text).last).style.color,
      Colors.red,
    );

    setStateController(() {
      security = PasswordSecurity.MEDIUM;
    });
    await tester.pumpAndSettle();

    expect(find.text('passwordSecurityMedium'), findsOneWidget);
    expect(
      tester.widget<Text>(find.byType(Text).last).style.color,
      Colors.orange,
    );

    setStateController(() {
      security = PasswordSecurity.HIGH;
    });
    await tester.pumpAndSettle();

    expect(find.text('passwordSecurityHigh'), findsOneWidget);
    expect(
      tester.widget<Text>(find.byType(Text).last).style.color,
      Colors.green,
    );
  });
}
