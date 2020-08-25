import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/screens/post_details_screen/widgets/export.dart';
import 'package:mooncake/ui/screens/post_details_screen/widgets/post_details_main_content/widgets/export.dart';
import 'package:mooncake/ui/screens/post_details_screen/widgets/post_details_main_content/widgets/post_comments_list/widgets/export.dart';
import 'package:mooncake/ui/screens/post_details_screen/widgets/post_details_main_content/widgets/post_details_reactions_list/widgets/reactions_list/widgets/export.dart';
import 'package:mooncake/ui/screens/post_details_screen/widgets/post_details_main_content/widgets/post_details_reactions_list/widgets/export.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:mooncake/ui/widgets/post_content/widgets/export.dart';

import '../../../../../mocks/mocks.dart';
import '../../../../helper.dart';

void main() {
  MockPostDetailsBloc mockPostDetailsBloc = MockPostDetailsBloc();
  MockAccountBloc mockAccountBloc = MockAccountBloc();
  MockNavigatorBloc mockNavigatorBloc = MockNavigatorBloc();
  MooncakeAccount userAccount = MooncakeAccount(
    profilePicUri: "https://example.com/avatar.png",
    moniker: "john-doe",
    cosmosAccount: cosmosAccount,
  );
  testWidgets('PostDetailsMainContent: Displays correctly',
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
          child: PostDetailsMainContent(),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byType(PostMessage), findsWidgets);
    expect(find.byType(LinkPreview), findsNothing);
    expect(find.byType(PostItemHeader), findsWidgets);
    expect(find.byType(AccountAvatar), findsWidgets);
    expect(find.text(testPosts[0].owner.screenName), findsWidgets);
    expect(find.byType(InkWell), findsWidgets);
    expect(find.byType(PostReactionItem), findsNothing);
    expect(find.byType(PostDetailsReactionsList), findsNothing);
    expect(find.byType(PostDetailsBottomBar), findsOneWidget);
    expect(find.byType(PostCommentAction), findsWidgets);
    expect(find.byType(PostAddReactionAction), findsWidgets);
    expect(find.byType(PostLikeAction), findsNothing);
    expect(find.byType(Tab), findsNWidgets(2));
    expect(
      find.descendant(
        of: find.byType(PostCommentsList),
        matching: find.byType(PostCommentItem),
      ),
      findsWidgets,
    );

    await tester.tap(find
        .descendant(
          of: find.byType(PostCommentsList),
          matching: find.byType(PostCommentItem),
        )
        .first);
    await tester.pumpAndSettle();
    expect(verify(mockNavigatorBloc.add(any)).callCount, 1);
  });

  testWidgets('PostDetailsMainContent: Displays empty reactions correctly',
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
          child: PostDetailsMainContent(),
        ),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.byType(Tab).last);
    await tester.pumpAndSettle();

    expect(find.byType(PostDetailsReactionsList), findsOneWidget);
    expect(find.byType(EmptyReactions), findsOneWidget);
    expect(find.text("noReactionsYet"), findsOneWidget);
  });

  testWidgets('PostDetailsMainContent: Displays reactions correctly',
      (WidgetTester tester) async {
    List<Reaction> reactionTest = [
      Reaction(user: userAccount, value: "123", code: "123"),
      Reaction(user: userAccount, value: "123", code: "123"),
      Reaction(user: userAccount, value: "123", code: "123"),
      Reaction(user: userAccount, value: "3", code: "123"),
    ];

    when(mockPostDetailsBloc.state).thenReturn(PostDetailsLoaded.first(
      user: userAccount,
      post: testPost.copyWith(reactions: reactionTest),
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
          child: PostDetailsMainContent(),
        ),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.byType(Tab).last);
    await tester.pumpAndSettle();

    expect(find.byType(PostDetailsReactionsList), findsOneWidget);
    expect(find.byType(EmptyReactions), findsNothing);
    expect(find.byType(ReactionFilterItem), findsWidgets);
    expect(find.byType(PostReactionItem), findsNWidgets(4));
    expect(find.text("noReactionsYet"), findsNothing);

    await tester.tap(find.text("3 1"));
    await tester.pumpAndSettle();
    expect(find.byType(PostReactionItem), findsNWidgets(1));
    expect(find.byType(AccountAvatar), findsWidgets);

    await tester.tap(find.byType(AccountAvatar).last);
    await tester.pumpAndSettle();
    expect(
        verify(mockNavigatorBloc.add(NavigateToUserDetails(userAccount)))
            .callCount,
        1);
  });
}
