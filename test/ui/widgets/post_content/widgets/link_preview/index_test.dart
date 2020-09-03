import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mooncake/entities/entities.dart';
import '../../../../helper.dart';
import 'package:mooncake/ui/widgets/post_content/widgets/export.dart';

void main() {
  testWidgets('PostReactionAction: Displays export correctly',
      (WidgetTester tester) async {
    var linkPreview = RichLinkPreview(
        title: 'null',
        description: 'null',
        image: '',
        appleIcon: 'null',
        favIcon: 'null',
        url: '');

    await tester.pumpWidget(makeTestableWidget(
      child: LinkPreview(
        preview: linkPreview,
      ),
    ));

    await tester.pumpAndSettle();

    expect(find.byType(GestureDetector), findsOneWidget);
    expect(find.text('😢'), findsNothing);
  });
}
