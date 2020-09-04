import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mooncake/ui/ui.dart';
import '../../../helper.dart';

void main() {
  testWidgets('Displays correctly', (WidgetTester tester) async {
    var tapValue = false;

    await tester.pumpWidget(
      makeTestableWidget(
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            void handleOnChange(bool value) {
              tapValue = value;
              setState(() {
                tapValue = value;
              });
            }

            return CheckBoxButton(onChanged: handleOnChange, value: tapValue);
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(Row), findsOneWidget);
    expect(find.byType(Checkbox), findsOneWidget);
    expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, false);

    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();
    expect(tapValue, true);

    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();
    expect(tapValue, false);

    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();
    expect(tapValue, true);
  });
}
