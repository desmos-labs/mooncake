import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:mooncake/ui/widgets/bottom_navigation_bar/widgets/export.dart';
// import '../helper.dart';

void main() {
  testWidgets('Displays correctly', (WidgetTester tester) async {
    // TabSelector()
    // await tester.pumpWidget(makeTestableWidget(
    //     child: Row(
    //   children: [Text("hi")],
    // )));

    await tester.pumpWidget(Localizations(delegates: [
      PostsLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ], locale: Locale('en'), child: ExportMnemonicPopup()));
    await tester.pumpAndSettle();

    debugDumpRenderTree();
    // MaterialApp(
    //   localizationsDelegates: [
    //     PostsLocalizations.delegate,
    //     GlobalMaterialLocalizations.delegate,
    //     GlobalWidgetsLocalizations.delegate,
    //     GlobalCupertinoLocalizations.delegate,
    //   ],
    //   supportedLocales: [
    //     const Locale('en'), // English, no country code
    //   ],
    //   home: TabSelector(),
    // ),
    // expect(find.byKey(PostsKeys.allPostsTab), findsOneWidget);
    // expect(find.byIcon(MooncakeIcons.plus), findsOneWidget);
    // expect(find.byKey(PostsKeys.accountTab), findsOneWidget);

    // print(tester.element(find.byType(Row)));
    // expect(find.byType(Text), findsOneWidget);
    // expect(BottomNavigationButton, findsOneWidget);
  });
}
