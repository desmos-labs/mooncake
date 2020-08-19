import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/screens/post_details_screen/widgets/export.dart';
import 'package:mooncake/ui/screens/post_details_screen/widgets/post_details_main_content/widgets/export.dart';
import 'package:mooncake/ui/screens/post_details_screen/widgets/post_details_main_content/widgets/post_comments_list/widgets/export.dart';
import 'package:mooncake/ui/screens/post_details_screen/widgets/post_details_main_content/widgets/post_details_reactions_list/widgets/export.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:mooncake/ui/widgets/post_content/widgets/export.dart';

import '../../../../../mocks/mocks.dart';
import '../../../../helper.dart';

void main() {
  testWidgets('PostDetailsMainContent: Displays correctly',
      (WidgetTester tester) async {
    MockPostDetailsBloc mockPostDetailsBloc = MockPostDetailsBloc();
    MockAccountBloc mockAccountBloc = MockAccountBloc();
    MockNavigatorBloc mockNavigatorBloc = MockNavigatorBloc();
    MooncakeAccount userAccount = MooncakeAccount(
      profilePicUri: "https://example.com/avatar.png",
      moniker: "john-doe",
      cosmosAccount: cosmosAccount,
    );

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
    expect(
      find.descendant(
        of: find.byType(PostCommentsList),
        matching: find.byType(PostCommentItem),
      ),
      findsWidgets,
    );

    // expect(find.byIcon(MooncakeIcons.poll), findsOneWidget);

    await tester.tap(find
        .descendant(
          of: find.byType(PostCommentsList),
          matching: find.byType(PostCommentItem),
        )
        .first);
    await tester.pumpAndSettle();
    expect(verify(mockNavigatorBloc.add(any)).callCount, 1);
  });
}
