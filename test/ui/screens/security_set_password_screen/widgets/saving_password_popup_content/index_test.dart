import 'package:flutter_test/flutter_test.dart';
import 'package:mooncake/ui/ui.dart';
import '../../../../helper.dart';
import 'package:mooncake/ui/screens/security_set_password_screen/widgets/export.dart';

void main() {
  testWidgets('SavingPasswordPopupContent: Displays correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      makeTestableWidget(
        child: SavingPasswordPopupContent(),
      ),
    );

    await tester.pump(const Duration(seconds: 3));
    expect(find.byType(LoadingIndicator), findsOneWidget);
    expect(find.text('savingPasswordTitle'), findsOneWidget);
    expect(find.text('savingPasswordBody'), findsOneWidget);
  });
}
