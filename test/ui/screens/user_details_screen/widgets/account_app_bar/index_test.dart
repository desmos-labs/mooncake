import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/screens/user_details_screen/widgets/account_app_bar/widgets/export.dart';
import 'package:mooncake/ui/screens/user_details_screen/widgets/export.dart';
import 'package:mooncake/ui/ui.dart';

import '../../../../../mocks/mocks.dart';
import '../../../../helper.dart';

void main() {
  var mockAccountBloc = MockAccountBloc();
  var mockNavigatorBloc = MockNavigatorBloc();
  var userAccount = MooncakeAccount(
    profilePicUri: 'https://example.com/avatar.png',
    moniker: 'john-doe',
    cosmosAccount: cosmosAccount,
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

    expect(find.text('walletButtonTooltip'), findsWidgets);
    expect(find.byType(AccountCoverImageViewer), findsOneWidget);
    expect(find.byType(AnimatedContainer), findsOneWidget);
    expect(find.byType(AccountAvatar), findsOneWidget);
    expect(find.byType(AccountOptionsButton), findsOneWidget);
    expect(find.byIcon(MooncakeIcons.settings), findsOneWidget);

    await tester.tap(find.byType(PrimaryButton));
    await tester.pumpAndSettle();
    expect(verify(mockNavigatorBloc.add(NavigateToWallet())).callCount, 1);

    await tester.tap(find.byIcon(MooncakeIcons.settings));
    await tester.pumpAndSettle();
    expect(find.text('logoutOption'), findsWidgets);
    expect(find.text('editAccountOption'), findsWidgets);
    expect(find.text('viewMnemonicOption'), findsWidgets);

    await tester.tap(find.text('editAccountOption'));
    await tester.pumpAndSettle();
    expect(verify(mockNavigatorBloc.add(NavigateToEditAccount())).callCount, 1);
  });

  testWidgets('AccountAppBar: Hits logout properly',
      (WidgetTester tester) async {
    var userAccount = MooncakeAccount(
      profilePicUri: 'https://example.com/avatar.png',
      moniker: 'john-doe',
      cosmosAccount: cosmosAccount.copyWith(address: 'address'),
    );

    when(mockAccountBloc.state).thenAnswer((_) {
      return LoggedIn.initial(userAccount, [userAccount]);
    });
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

    await tester.tap(find.byIcon(MooncakeIcons.settings));
    await tester.pumpAndSettle();
    expect(find.text('logoutOption'), findsWidgets);
    expect(find.text('editAccountOption'), findsWidgets);
    expect(find.text('viewMnemonicOption'), findsWidgets);

    await tester.tap(find.text('logoutOption'));
    await tester.pumpAndSettle();
    expect(verify(mockAccountBloc.add(LogOut('address'))).callCount, 1);
  });
}
