import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../../helper.dart';
import 'package:mooncake/ui/screens/user_wallet_screen/widgets/export.dart';

void main() {
  testWidgets('WalletActionsList: Displays correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      makeTestableWidget(
        child: WalletActionsList(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('walletTitle'), findsOneWidget);
    expect(find.text('walletBodyText'), findsOneWidget);
    expect(tester.widget<Image>(find.byType(Image)).width, 150);
  });
}
