// import 'package:flutter_test/flutter_test.dart';
// import 'package:flutter/material.dart';
// import 'package:mooncake/ui/ui.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// // import 'package:mooncake/ui/widgets/bottom_navigation_bar/widgets/export.dart';
// import '../helper.dart';

// void main() {
//   testWidgets('Displays correctly', (WidgetTester tester) async {
//     // await tester.pumpWidget(
//     //   makeTestableWidget(
//     child: TabSelector(),
//     //   ),
//     // );

//     await tester.pumpWidget(Localizations(delegates: [
//       PostsLocalizations.delegateTest,
//       GlobalMaterialLocalizations.delegate,
//       GlobalWidgetsLocalizations.delegate,
//       GlobalCupertinoLocalizations.delegate,
//     ], locale: Locale('en'), child: TabSelector()));
//     await tester.pumpAndSettle();
//     // MaterialApp(
//     //   localizationsDelegates: [
//     //     PostsLocalizations.delegate,
//     //     GlobalMaterialLocalizations.delegate,
//     //     GlobalWidgetsLocalizations.delegate,
//     //     GlobalCupertinoLocalizations.delegate,
//     //   ],
//     //   supportedLocales: [
//     //     const Locale('en'), // English, no country code
//     //   ],
//     //   home: TabSelector(),
//     // ),
//     // debugDumpRenderTree();
//     // expect(find.byKey(PostsKeys.allPostsTab), findsOneWidget);
//     // expect(find.byIcon(MooncakeIcons.plus), findsOneWidget);
//     // expect(find.byKey(PostsKeys.accountTab), findsOneWidget);

//     // print(tester.element(find.byType(Row)));
//     // expect(find.byType(Text), findsOneWidget);
//     // expect(BottomNavigationButton, findsOneWidget);
//   });
// }
