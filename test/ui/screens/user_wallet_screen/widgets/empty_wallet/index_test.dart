import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../../helper.dart';
import 'package:mooncake/ui/screens/user_wallet_screen/widgets/export.dart';

void main() {
  testWidgets('EmptyWallet: Displays correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      makeTestableWidget(
        child: EmptyWallet(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('emptyWalletTitle'), findsOneWidget);
    expect(find.text('emptyWalletBody'), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
    expect(find.byType(Column), findsOneWidget);
  });
}
