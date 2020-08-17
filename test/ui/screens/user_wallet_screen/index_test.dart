import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/ui/ui.dart';
import '../../helper.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/screens/user_wallet_screen/widgets/export.dart';

void main() {
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

  testWidgets('WalletScreen: Displays correctly', (WidgetTester tester) async {
    when(mockAccountBloc.state)
        .thenAnswer((_) => LoggedIn.initial(userAccount));
    await tester.pumpWidget(
      makeTestableWidget(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<AccountBloc>(
              create: (_) => mockAccountBloc,
            ),
          ],
          child: WalletScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(RefreshIndicator), findsOneWidget);
    expect(find.byType(WalletHeader), findsOneWidget);
    expect(find.byType(WalletActionsList), findsOneWidget);
  });
}
