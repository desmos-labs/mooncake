import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../../helper.dart';
import 'package:mooncake/ui/screens/user_wallet_screen/widgets/export.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';

void main() {
  testWidgets('WalletHeader: Displays correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      makeTestableWidget(
        child: WalletHeader(
          coin: StdCoin(amount: '10000', denom: 'udaric'),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(Column), findsOneWidget);
    expect(find.byType(Text), findsNWidgets(2));
    expect(find.byIcon(MooncakeIcons.transactions), findsOneWidget);
  });
}
