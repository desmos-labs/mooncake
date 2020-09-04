import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mooncake/ui/ui.dart';

import '../../../test_utils/export.dart';

void main() {
  testWidgets('Local cover image', (WidgetTester tester) async {
    final file = 'file:/home/user/image.png';

    await tester.pumpWidget(MediaQuery(
      data: MediaQueryData(),
      child: AccountCoverImageViewer(coverImage: file),
    ));

    expect(find.byWidgetPredicate((widget) {
      return widget is Image && widget.image == FileImage(File(file));
    }), findsOneWidget);
    expect(find.byType(Container), findsNothing);
  });

  testWidgets('Remove cover image', (WidgetTester tester) async {
    await provideMockedNetworkImages(() async {
      final url = 'https://example.com';
      await tester.pumpWidget(MediaQuery(
        data: MediaQueryData(),
        child: AccountCoverImageViewer(coverImage: url),
      ));

      expect(find.byWidgetPredicate((widget) {
        return widget is Image && widget.image == NetworkImage(url);
      }), findsOneWidget);
      expect(find.byType(Container), findsNothing);
    });
  });

  testWidgets('No cover', (WidgetTester tester) async {
    await tester.pumpWidget(MediaQuery(
      data: MediaQueryData(),
      child: AccountCoverImageViewer(coverImage: null),
    ));

    expect(find.byType(Image), findsNothing);
    expect(find.byWidgetPredicate((widget) {
      return widget is Container &&
          // Blue is the default primary swatch
          widget.color == Colors.blue.withOpacity(0.25);
    }), findsOneWidget);
  });
}
