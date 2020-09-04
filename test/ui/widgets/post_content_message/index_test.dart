import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:mooncake/ui/ui.dart';
import '../../helper.dart';
import '../../../mocks/posts.dart';

void main() {
  testWidgets('PostMessage: Displays correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      makeTestableWidget(
        child: PostMessage(post: testPost),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(MarkdownBody), findsOneWidget);
    expect(
      tester.widget<MarkdownBody>(find.byType(MarkdownBody)).data,
      testPost.message.replaceAll('\n', '  \n'),
    );
  });
}
