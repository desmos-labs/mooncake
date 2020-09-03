import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mooncake/entities/entities.dart';
import '../../../../../../helper.dart';
import '../../../../../../../mocks/posts.dart';
import 'package:mooncake/ui/widgets/post_content/widgets/post_poll_content/widgets/export.dart';

void main() {
  testWidgets('PostPollOptionItem: Displays export correctly',
      (WidgetTester tester) async {
    var option = PollOption(id: 1, text: 'apples');

    await tester.pumpWidget(makeTestableWidget(
      child: PostPollOptionItem(
        post: testPost,
        option: option,
        index: 1,
      ),
    ));

    await tester.pumpAndSettle();

    expect(find.byType(FlatButton), findsOneWidget);
    expect(find.text('apples'), findsOneWidget);
  });
}
