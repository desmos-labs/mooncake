import 'package:flutter_test/flutter_test.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:flutter/material.dart';
import '../../../../helper.dart';
import 'package:mooncake/ui/screens/post_details_screen/widgets/export.dart';

void main() {
  testWidgets('PostDetailsLoading: Displays correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      makeTestableWidget(
        child: PostDetailsLoading(),
      ),
    );

    await tester.pump(const Duration(seconds: 3));

    expect(find.byType(LoadingIndicator), findsOneWidget);
    expect(find.byType(Column), findsOneWidget);
    expect(find.text('loadingPost'), findsOneWidget);
  });
}
