import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mooncake/ui/ui.dart';
import '../../helper.dart';

void main() {
  testWidgets('PostsListEmptyContainer: Displays export correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      makeTestableWidget(
        child: PostsListEmptyContainer(),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('noPostsYet'), findsOneWidget);
    expect(
      tester.widget<Container>(find.byType(Container)).key,
      Key('__postsEmptyContainer__'),
    );
  });
}
