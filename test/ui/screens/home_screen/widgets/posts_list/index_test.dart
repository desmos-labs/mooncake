import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/ui/ui.dart';
import '../../../../../mocks/posts.dart';
import '../../../../helper.dart';
import 'package:mooncake/ui/screens/home_screen/widgets/export.dart';
import 'package:mooncake/ui/screens/home_screen/widgets/posts_list/widgets/export.dart';

void main() {
  testWidgets('PostsList: Displays correctly', (WidgetTester tester) async {
    MockAccountBloc mockAccountBloc = MockAccountBloc();
    MockPostsListBloc mockPostsListBloc = MockPostsListBloc();
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
    when(mockPostsListBloc.state)
        .thenReturn(PostsLoaded.first(posts: testPosts));
    when(mockAccountBloc.state).thenReturn(LoggedIn.initial(userAccount));
    await tester.pumpWidget(
      makeTestableWidget(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<PostsListBloc>(create: (_) => mockPostsListBloc),
            BlocProvider<AccountBloc>(create: (_) => mockAccountBloc),
          ],
          child: PostsList(),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byType(PostsLoadingEmptyContainer), findsNothing);
    expect(find.byType(PostListItem), findsWidgets);
    expect(find.byType(CustomScrollView), findsOneWidget);
    expect(find.byType(ErrorPostMessage), findsNothing);
  });

  testWidgets('PostsList: Error Displays correctly',
      (WidgetTester tester) async {
    MockAccountBloc mockAccountBloc = MockAccountBloc();
    MockPostsListBloc mockPostsListBloc = MockPostsListBloc();
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

    Post testErrorPost =
        testPost.copyWith(status: PostStatus(value: PostStatusValue.ERRORED));

    when(mockPostsListBloc.state)
        .thenReturn(PostsLoaded.first(posts: [testErrorPost, ...testPosts]));
    when(mockAccountBloc.state).thenReturn(LoggedIn.initial(userAccount));

    await tester.pumpWidget(
      makeTestableWidget(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<PostsListBloc>(create: (_) => mockPostsListBloc),
            BlocProvider<AccountBloc>(create: (_) => mockAccountBloc),
          ],
          child: PostsList(),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byType(ErrorPostMessage), findsOneWidget);
    expect(find.byType(ErrorPost), findsOneWidget);
    expect(find.byIcon(MooncakeIcons.syncing), findsOneWidget);
    expect(find.byIcon(MooncakeIcons.delete), findsOneWidget);

    await tester.tap(find.byIcon(MooncakeIcons.syncing));
    await tester.pumpAndSettle();
    expect(
        verify(mockPostsListBloc.add(RetryPostUpload(testErrorPost))).callCount,
        1);

    await tester.tap(find.byIcon(MooncakeIcons.delete));
    await tester.pumpAndSettle();
    expect(
        verify(mockPostsListBloc.add(DeletePost(testErrorPost))).callCount, 1);
  });
}
