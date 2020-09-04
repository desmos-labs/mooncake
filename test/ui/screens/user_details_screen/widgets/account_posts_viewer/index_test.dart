import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/screens/user_details_screen/widgets/export.dart';
import 'package:mooncake/ui/ui.dart';

import '../../../../../mocks/mocks.dart';
import '../../../../helper.dart';

void main() {
  var mockPostsListBloc = MockPostsListBloc();
  var mockAccountBloc = MockAccountBloc();
  var userAccount = MooncakeAccount(
    profilePicUri: 'https://example.com/avatar.png',
    moniker: 'john-doe',
    cosmosAccount: cosmosAccount,
  );
  testWidgets('AccountPostsViewer: Displays correctly',
      (WidgetTester tester) async {
    when(mockAccountBloc.state)
        .thenAnswer((_) => LoggedIn.initial(userAccount, [userAccount]));
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
        .thenAnswer((_) => LoggedIn.initial(userAccount, [userAccount]));
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
