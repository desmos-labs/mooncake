import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:mooncake/ui/ui.dart';
import '../../../../helper.dart';
import 'package:mooncake/ui/screens/home_screen/widgets/export.dart';

void main() {
  testWidgets('postsAppBar: Displays export correctly',
      (WidgetTester tester) async {
    var mockNavigatorBloc = MockNavigatorBloc();

    await tester.pumpWidget(
      makeTestableWidget(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<NavigatorBloc>(
              create: (_) => mockNavigatorBloc,
            ),
          ],
          child: Builder(
            builder: (BuildContext context) {
              return postsAppBar(context);
            },
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('appName'), findsOneWidget);
    expect(tester.widget<AppBar>(find.byType(AppBar)).centerTitle, true);
  });
}
