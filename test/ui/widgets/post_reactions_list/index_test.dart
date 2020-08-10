import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mooncake/ui/ui.dart';
import '../../../mocks/posts.dart';
import '../helper.dart';

void main() {
  testWidgets('PostReactionsList: Displays export correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      makeTestableWidget(
        child: PostReactionsList(post: testPost),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byIcon(MooncakeIcons.more), findsNothing);
    expect(find.byType(Wrap), findsOneWidget);
  });
}
