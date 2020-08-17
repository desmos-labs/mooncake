import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter/material.dart';
import 'package:mooncake/ui/ui.dart';
import '../../../../helper.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/screens/user_details_screen/widgets/export.dart';
import 'package:mooncake/ui/screens/user_details_screen/widgets/account_app_bar/widgets/export.dart';

void main() {
  MockAccountBloc mockAccountBloc = MockAccountBloc();
  MockNavigatorBloc mockNavigatorBloc = MockNavigatorBloc();
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

  testWidgets('AccountAppBar: Displays correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      makeTestableWidget(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<AccountBloc>(
              create: (_) => mockAccountBloc,
            ),
            BlocProvider<NavigatorBloc>(
              create: (_) => mockNavigatorBloc,
            ),
          ],
          child: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool isBoxedScrolled) {
              return [
                AccountAppBar(
                  user: userAccount,
                  isMyProfile: true,
                  isFollower: false,
                ),
              ];
            },
            body: Container(),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text("walletButtonTooltip"), findsWidgets);
    expect(find.byType(AccountCoverImageViewer), findsOneWidget);
    expect(find.byType(AnimatedContainer), findsOneWidget);
    expect(find.byType(AccountAvatar), findsOneWidget);
    expect(find.byType(AccountOptionsButton), findsOneWidget);
    expect(find.byIcon(MooncakeIcons.more), findsOneWidget);

    await tester.tap(find.byType(PrimaryButton));
    await tester.pumpAndSettle();
    expect(verify(mockNavigatorBloc.add(NavigateToWallet())).callCount, 1);

    await tester.tap(find.byIcon(MooncakeIcons.more));
    await tester.pumpAndSettle();
    expect(find.text("logoutOption"), findsWidgets);
    expect(find.text("editAccountOption"), findsWidgets);
    expect(find.text("viewMnemonicOption"), findsWidgets);

    await tester.tap(find.text("editAccountOption"));
    await tester.pumpAndSettle();
    expect(verify(mockNavigatorBloc.add(NavigateToEditAccount())).callCount, 1);
  });
}
