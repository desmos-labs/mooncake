import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mooncake/ui/ui.dart';
import '../../helper.dart';

void main() {
  testWidgets('SyncSnackBar: Displays export correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      makeTestableWidget(
        child: SyncSnackBar(),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byType(SizedBox), findsWidgets);
    expect(find.byIcon(FontAwesomeIcons.cloudUploadAlt), findsOneWidget);
    expect(find.text('syncingActivities'), findsOneWidget);
  });
}
