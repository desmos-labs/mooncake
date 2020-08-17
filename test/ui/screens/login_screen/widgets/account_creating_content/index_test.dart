import 'package:flutter_test/flutter_test.dart';
import 'package:mooncake/ui/ui.dart';
import '../../../../helper.dart';
import 'package:mooncake/ui/screens/login_screen/widgets/export.dart';

void main() {
  testWidgets('CreatingAccountPopupContent: Displays correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      makeTestableWidget(
        child: CreatingAccountPopupContent(),
      ),
    );

    await tester.pump(const Duration(seconds: 3));

    expect(find.byType(LoadingIndicator), findsOneWidget);
    expect(
      find.text(
        'creatingAccountPopupTitle'.toUpperCase(),
      ),
      findsOneWidget,
    );
    expect(
      find.text('creatingAccountText'),
      findsOneWidget,
    );
  });
}
