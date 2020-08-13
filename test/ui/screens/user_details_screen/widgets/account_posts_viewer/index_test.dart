import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter/material.dart';
import 'package:mooncake/ui/ui.dart';
import '../../../../../mocks/posts.dart';
import '../../../../helper.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/screens/user_details_screen/widgets/export.dart';

void main() {
  MockPostsListBloc mockPostsListBloc = MockPostsListBloc();
  MockAccountBloc mockAccountBloc = MockAccountBloc();
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
  testWidgets('AccountPostsViewer: Displays correctly',
      (WidgetTester tester) async {
    when(mockAccountBloc.state)
        .thenAnswer((_) => LoggedIn.initial(userAccount));
    await tester.pumpWidget(
      makeTestableWidget(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<AccountBloc>(
              create: (_) => mockAccountBloc,
            ),
            BlocProvider<PostsListBloc>(
              create: (_) => mockPostsListBloc,
            ),
          ],
          child: Container(
            child: AccountPostsViewer(posts: testPosts),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(PostListItem), findsWidgets);
  });

  testWidgets('AccountPostsViewer: Displays no posts correctly',
      (WidgetTester tester) async {
    when(mockAccountBloc.state)
        .thenAnswer((_) => LoggedIn.initial(userAccount));
    await tester.pumpWidget(
      makeTestableWidget(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<AccountBloc>(
              create: (_) => mockAccountBloc,
            ),
            BlocProvider<PostsListBloc>(
              create: (_) => mockPostsListBloc,
            ),
          ],
          child: Container(
            child: AccountPostsViewer(posts: []),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(PostsListEmptyContainer), findsOneWidget);
    expect(find.byType(PostListItem), findsNothing);
  });
}
