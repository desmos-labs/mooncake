import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:mooncake/ui/widgets/posts_list_item/widgets/export.dart';
import 'package:mooncake/ui/widgets/posts_list_item/widgets/post_actions_bar/widgets/export.dart';

import '../../../../../mocks/mocks.dart';
import '../../../../helper.dart';

void main() {
  testWidgets('PostActionsBar: Displays export correctly',
      (WidgetTester tester) async {
    var mockAccountBloc = MockAccountBloc();
    var userAccount = MooncakeAccount(
      profilePicUri: 'https://example.com/avatar.png',
      moniker: 'john-doe',
      cosmosAccount: cosmosAccount,
    );
    when(mockAccountBloc.state)
        .thenReturn(LoggedIn.initial(userAccount, [userAccount]));

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
