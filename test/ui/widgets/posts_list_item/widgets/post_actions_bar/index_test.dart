import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:mooncake/ui/widgets/posts_list_item/widgets/export.dart';
import 'package:mooncake/ui/widgets/posts_list_item/widgets/post_actions_bar/widgets/export.dart';
import '../../../../helper.dart';
import '../../../../../mocks/posts.dart';

void main() {
  testWidgets('PostActionsBar: Displays export correctly',
      (WidgetTester tester) async {
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
    when(mockAccountBloc.state).thenReturn(LoggedIn.initial(userAccount));

    await tester.pumpWidget(
      makeTestableWidget(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<AccountBloc>(
              create: (_) => mockAccountBloc,
            ),
          ],
          child: PostActionsBar(post: testPost),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(PostCommentAction), findsOneWidget);
    expect(find.byType(PostAddReactionAction), findsOneWidget);
    expect(find.byType(PostLikesCounter), findsNothing);
    expect(find.byType(AccountAvatar), findsNothing);
  });
}
