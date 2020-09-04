import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/screens/user_details_screen/widgets/export.dart';
import 'package:mooncake/ui/ui.dart';

import '../../../mocks/mocks.dart';
import '../../helper.dart';

void main() {
  var mockAccountBloc = MockAccountBloc();
  var mockNavigatorBloc = MockNavigatorBloc();
  var mockPostsListBloc = MockPostsListBloc();
  var mockHomeBloc = MockHomeBloc();

  var userAccount = MooncakeAccount(
    profilePicUri: 'https://example.com/avatar.png',
    moniker: 'john-doe',
    cosmosAccount: cosmosAccount,
  );

  testWidgets('UserDetailsScreen: Displays correctly',
      (WidgetTester tester) async {
    when(mockHomeBloc.state).thenAnswer((_) => HomeState.initial());
    when(mockAccountBloc.state)
        .thenAnswer((_) => LoggedIn.initial(userAccount, [userAccount]));
    await tester.pumpWidget(
      makeTestableWidget(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<AccountBloc>(
              create: (_) => mockAccountBloc,
            ),
            BlocProvider<NavigatorBloc>(
              create: (_) => mockNavigatorBloc,
            ),
            BlocProvider<PostsListBloc>(
              create: (_) => mockPostsListBloc,
            ),
            BlocProvider<HomeBloc>(
              create: (_) => mockHomeBloc,
            ),
          ],
          child: UserDetailsScreen(
            user: userAccount,
            isMyProfile: true,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(TabSelector), findsOneWidget);
    expect(find.byType(AccountAppBar), findsOneWidget);
    expect(find.byType(AccountPostsViewer), findsOneWidget);
  });
}
