import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:flutter/material.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:mooncake/ui/widgets/post_item_header/widgets/export.dart';
import '../helper.dart';
import '../../../mocks/posts.dart';

void main() {
  testWidgets('PostItemHeader: Displays correctly',
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
          child: PostItemHeader(post: testPost),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(InkWell), findsWidgets);
    expect(find.text('desmos1y35...4x93h'), findsOneWidget);
    expect(find.byType(PostMoreButton), findsOneWidget);
  });
}
