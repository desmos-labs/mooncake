import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mooncake/ui/widgets/posts_list_item/widgets/export.dart';
import '../../../../helper.dart';

void main() {
  testWidgets('PostSuccessPopupContent: Displays export correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      makeTestableWidget(
        child: PostSuccessPopupContent(txHash: 'txHash...'),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('syncSuccessBrowseButton'), findsOneWidget);
    expect(find.byType(FlatButton), findsOneWidget);
  });
}
