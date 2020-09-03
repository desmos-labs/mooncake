import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mooncake/ui/ui.dart';
import '../../../mocks/posts.dart';
import '../../helper.dart';

void main() {
  testWidgets('MnemonicVisualizer: Displays export correctly',
      (WidgetTester tester) async {
    StateSetter setStateController;
    var isLiked = false;

    await tester.pumpWidget(
      makeTestableWidget(
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            setStateController = setState;
            return PostLikeAction(post: testPost, isLiked: isLiked);
          },
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byIcon(MooncakeIcons.heart), findsOneWidget);

    setStateController(() {
      isLiked = true;
    });
    await tester.pumpAndSettle();

    expect(find.byIcon(MooncakeIcons.heart), findsNothing);
    expect(find.byIcon(MooncakeIcons.heartF), findsOneWidget);
  });
}
