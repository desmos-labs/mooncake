import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/ui/ui.dart';
import '../../helper.dart';
import 'package:mooncake/ui/screens/post_details_screen/widgets/export.dart';
import '../../../mocks/mocks.dart';
import 'package:mooncake/entities/entities.dart';

void main() {
  MockPostDetailsBloc mockPostDetailsBloc = MockPostDetailsBloc();
  MockAccountBloc mockAccountBloc = MockAccountBloc();
  MockNavigatorBloc mockNavigatorBloc = MockNavigatorBloc();
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
  testWidgets('PostDetailsScreen: Displays correctly',
      (WidgetTester tester) async {
    when(mockPostDetailsBloc.state).thenReturn(PostDetailsLoaded.first(
      user: userAccount,
      post: testPost,
      comments: testPosts,
    ));

    when(mockAccountBloc.state).thenReturn(LoggedIn.initial(userAccount));

    await tester.pumpWidget(
      makeTestableWidget(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<PostDetailsBloc>(
              create: (_) => mockPostDetailsBloc,
            ),
            BlocProvider<AccountBloc>(
              create: (_) => mockAccountBloc,
            ),
            BlocProvider<NavigatorBloc>(
              create: (_) => mockNavigatorBloc,
            ),
          ],
          child: PostDetailsScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byType(PostDetailsMainContent), findsOneWidget);
  });

  testWidgets('PostDetailsScreen: Displays Loading correctly',
      (WidgetTester tester) async {
    when(mockPostDetailsBloc.state).thenReturn(LoadingPostDetails());

    await tester.pumpWidget(
      makeTestableWidget(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<PostDetailsBloc>(
              create: (_) => mockPostDetailsBloc,
            ),
            BlocProvider<AccountBloc>(
              create: (_) => mockAccountBloc,
            ),
            BlocProvider<NavigatorBloc>(
              create: (_) => mockNavigatorBloc,
            ),
          ],
          child: PostDetailsScreen(),
        ),
      ),
    );

    await tester.pump(const Duration(seconds: 5));
    expect(find.byType(PostDetailsMainContent), findsNothing);
    expect(find.byType(PostDetailsLoading), findsOneWidget);
  });
}
