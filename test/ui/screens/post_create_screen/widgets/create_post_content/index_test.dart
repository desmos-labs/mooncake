import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter/material.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mooncake/ui/screens/post_create_screen/blocs/export.dart';
import 'package:mooncake/ui/screens/post_create_screen/widgets/export.dart';
import '../../../../../mocks/mocks.dart';
import 'package:mooncake/ui/screens/post_create_screen/widgets/create_post_content/widgets/export.dart';
import '../../../../helper.dart';

class MockPostInputBloc extends MockBloc<PostInputEvent, PostInputState>
    implements PostInputBloc {}

void main() {
  testWidgets('CreatePostContent: Displays correctly',
      (WidgetTester tester) async {
    MockPostInputBloc mockPostInputBloc = MockPostInputBloc();
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
    when(mockPostInputBloc.state).thenReturn(PostInputState.empty(testPost));

    await tester.pumpWidget(
      makeTestableWidget(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<AccountBloc>(
              create: (_) => mockAccountBloc,
            ),
            BlocProvider<PostInputBloc>(
              create: (_) => mockPostInputBloc,
            ),
          ],
          child: CreatePostContent(
            parentPost: testPost,
            bottomPadding: 10,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(CreatePostTopBar), findsOneWidget);
    expect(find.byType(PostContent), findsOneWidget);
    expect(find.byType(PostPollCreator), findsNothing);
  });
}
