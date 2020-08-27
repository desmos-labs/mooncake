import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:mooncake/ui/ui.dart';
import '../../../helper.dart';

void main() {
  testWidgets('Displays correctly in light mode', (WidgetTester tester) async {
    bool enabledValue = true;

    await tester.pumpWidget(
      makeTestableWidget(
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            void handleOnPressed() {
              setState(() {
                enabledValue = !enabledValue;
              });
            }

            return PrimaryButton(
                child: Text("pineapples"),
                onPressed: handleOnPressed,
                enabled: enabledValue);
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(GradientButton), findsOneWidget);
    expect(tester.widget<GradientButton>(find.byType(GradientButton)).isEnabled,
        true);

    await tester.tap(find.byType(GradientButton));
    await tester.pumpAndSettle();
    expect(tester.widget<GradientButton>(find.byType(GradientButton)).isEnabled,
        false);
  });

  testWidgets('Displays correctly in dark mode', (WidgetTester tester) async {
    bool enabledValue = true;
    await tester.pumpWidget(
      makeTestableWidget(
        theme: 'dark',
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            void handleOnPressed() {
              setState(() {
                enabledValue = !enabledValue;
              });
            }

            return PrimaryButton(
                child: Text("pineapples"),
                onPressed: handleOnPressed,
                enabled: enabledValue);
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(GradientButton), findsOneWidget);
    expect(find.byType(FlatButton), findsNothing);
  });
}
