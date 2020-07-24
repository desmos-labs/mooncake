import 'package:flutter_test/flutter_test.dart';
import 'package:mooncake/ui/ui.dart';

void main() {
  testWidgets('Displays correctly', (WidgetTester tester) async {
    await tester.pumpWidget(TabSelector());

    expect(find.byKey(PostsKeys.allPostsTab), findsOneWidget);
    expect(find.byIcon(MooncakeIcons.plus), findsOneWidget);
    expect(find.byKey(PostsKeys.accountTab), findsOneWidget);
  });
}
