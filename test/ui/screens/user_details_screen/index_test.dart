import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/ui/ui.dart';
import '../../helper.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/screens/user_details_screen/widgets/export.dart';

void main() {
  MockAccountBloc mockAccountBloc = MockAccountBloc();
  MockNavigatorBloc mockNavigatorBloc = MockNavigatorBloc();
  MockPostsListBloc mockPostsListBloc = MockPostsListBloc();
  MockHomeBloc mockHomeBloc = MockHomeBloc();

  MooncakeAccount userAccount = MooncakeAccount(
    profilePicUri: "https://example.com/avatar.png",
    moniker: "john-doe",
    cosmosAccount: CosmosAccount(
      accountNumber: 153,
      address: "desmos1ew60ztvqxlf5kjjyyzxf7hummlwdadgesu3725",
      coins: [
        StdCoin(amount: "10000", denom: "udaric"),
      ],
      sequence: 45,
    ),
  );

  testWidgets('UserDetailsScreen: Displays correctly',
      (WidgetTester tester) async {
    when(mockHomeBloc.state).thenAnswer((_) => HomeState.initial());
    when(mockAccountBloc.state)
        .thenAnswer((_) => LoggedIn.initial(userAccount));
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
