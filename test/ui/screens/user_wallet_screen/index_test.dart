import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/screens/user_wallet_screen/widgets/export.dart';
import 'package:mooncake/ui/ui.dart';

import '../../../mocks/mocks.dart';
import '../../helper.dart';

void main() {
  var mockAccountBloc = MockAccountBloc();

  var userAccount = MooncakeAccount(
    profilePicUri: 'https://example.com/avatar.png',
    moniker: 'john-doe',
    cosmosAccount: cosmosAccount,
  );

  testWidgets('WalletScreen: Displays correctly', (WidgetTester tester) async {
    when(mockAccountBloc.state)
        .thenAnswer((_) => LoggedIn.initial(userAccount, [userAccount]));
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
