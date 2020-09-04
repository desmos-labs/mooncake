import 'package:flutter_test/flutter_test.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/screens/user_details_screen/widgets/export.dart';
import 'package:mooncake/ui/ui.dart';

import '../../../../../mocks/mocks.dart';
import '../../../../helper.dart';

void main() {
  var userAccount = MooncakeAccount(
    profilePicUri: 'https://example.com/avatar.png',
    moniker: 'john-doe',
    cosmosAccount: cosmosAccount,
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
