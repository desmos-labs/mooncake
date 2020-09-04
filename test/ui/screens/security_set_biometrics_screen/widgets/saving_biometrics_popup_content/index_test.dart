import 'package:flutter_test/flutter_test.dart';
import 'package:mooncake/ui/ui.dart';
import '../../../../helper.dart';
import 'package:mooncake/ui/screens/security_set_biometrics_screen/widgets/export.dart';

void main() {
  testWidgets('SavingBiometricsPopupContent: Displays correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      makeTestableWidget(
        child: SavingBiometricsPopupContent(),
      ),
    );
    await tester.pump(const Duration(seconds: 3));
    expect(find.byType(LoadingIndicator), findsOneWidget);
    expect(find.text('savingBiometricsTitle'), findsOneWidget);
    expect(find.text('savingBiometricsBody'), findsOneWidget);
  });
}
