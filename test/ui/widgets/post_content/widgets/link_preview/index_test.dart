import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';
import '../../../helper.dart';
import 'package:mooncake/ui/widgets/post_content/widgets/export.dart';

void main() {
  testWidgets('PostReactionAction: Displays export correctly',
      (WidgetTester tester) async {
    RichLinkPreview linkPreview = RichLinkPreview(
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
    expect(find.text('😢'), findsOneWidget);
  });
}
