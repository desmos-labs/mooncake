import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:mooncake/entities/app/app_tab.dart';
import 'package:mooncake/ui/widgets/bottom_navigation_bar/widgets/export.dart';
import '../../../../helper.dart';

void main() {
  testWidgets('Displays correctly', (WidgetTester tester) async {
    var mockHomeBloc = MockHomeBloc();
    var mockNavigatorBloc = MockNavigatorBloc();
    when(mockHomeBloc.state).thenReturn(HomeState.initial());

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<NavigatorBloc>(
            create: (_) => mockNavigatorBloc,
          ),
          BlocProvider<HomeBloc>(
            create: (_) => mockHomeBloc,
          ),
        ],
        child: makeTestableWidget(
          child: BottomNavigationButton(
            key: PostsKeys.allPostsTab,
            tab: AppTab.home,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byKey(PostsKeys.allPostsTab), findsWidgets);
    expect(find.byType(IconButton), findsOneWidget);
  });
}
