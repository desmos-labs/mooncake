import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/widgets/post_content/widgets/export.dart';
import '../../../mocks/posts.dart';
import '../helper.dart';

void main() {
  testWidgets('PostContent: Displays export correctly',
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
          child: Container(
            child: PostContent(post: testUiPost),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(PostItemHeader), findsOneWidget);
    expect(find.byType(PostImagesPreviewer), findsOneWidget);
    expect(find.byType(PostPollContent), findsNothing);
  });
}
