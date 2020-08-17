import 'package:flutter_test/flutter_test.dart';
import 'package:mooncake/ui/widgets/posts_list_item/widgets/export.dart';
import '../../../../helper.dart';

void main() {
  testWidgets('PostErrorPopupContent: Displays export correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      makeTestableWidget(
        child: PostErrorPopupContent(error: 'a big error'),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('syncErrorTitle'), findsOneWidget);
    expect(find.text('syncErrorDesc'), findsOneWidget);
    expect(find.text('syncErrorCopyButton'), findsOneWidget);
  });
}
