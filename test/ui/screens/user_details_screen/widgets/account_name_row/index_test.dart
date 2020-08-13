import 'package:flutter_test/flutter_test.dart';
import 'package:mooncake/ui/ui.dart';
import '../../../../helper.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/screens/user_details_screen/widgets/export.dart';

void main() {
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

  testWidgets('AccountNameRow: Displays correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      makeTestableWidget(
        child: AccountNameRow(
          user: userAccount,
          isMyProfile: true,
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text(userAccount.screenName), findsOneWidget);
  });
}
