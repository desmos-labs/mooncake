import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:mooncake/ui/widgets/bottom_navigation_bar/widgets/export.dart';
import '../../helper.dart';

void main() {
  testWidgets('Displays correctly', (WidgetTester tester) async {
    var mockHomeBloc = MockHomeBloc();
    var mockNavigatorBloc = MockNavigatorBloc();
    when(mockHomeBloc.state).thenReturn(HomeState.initial());

    await tester.pumpWidget(
      makeTestableWidget(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<NavigatorBloc>(
              create: (_) => mockNavigatorBloc,
            ),
            BlocProvider<HomeBloc>(
              create: (_) => mockHomeBloc,
            ),
          ],
          child: TabSelector(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byIcon(MooncakeIcons.plus), findsOneWidget);
    expect(find.byType(Row), findsOneWidget);
    expect(find.byType(MaterialButton), findsOneWidget);
    expect(find.byType(BottomNavigationButton), findsNWidgets(2));
  });
}
