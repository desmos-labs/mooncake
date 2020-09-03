import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/screens/user_details_screen/widgets/export.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:mooncake/ui/screens/user_details_screen/widgets/menu_drawer/widgets/export.dart';

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

  testWidgets('MenuDrawer: Displays correctly', (WidgetTester tester) async {
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
          child: MenuDrawer(
            user: userAccount,
            accounts: [userAccount],
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('logoutAll'), findsOneWidget);
    expect(find.byType(SingleAccountItem), findsWidgets);
    expect(find.byType(Drawer), findsOneWidget);
  });

  testWidgets('MenuDrawer: Create account gesture',
      (WidgetTester tester) async {
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
          child: MenuDrawer(
            user: userAccount,
            accounts: [userAccount],
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.text('createAnotherAccount'));
    await tester.pumpAndSettle();
    expect(
        verify(mockAccountBloc.add(GenerateAccountWhileLoggedIn())).callCount,
        1);
  });

  testWidgets('MenuDrawer: Logout gesture', (WidgetTester tester) async {
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
          child: MenuDrawer(
            user: userAccount,
            accounts: [userAccount],
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.text('logoutAll'));
    await tester.pumpAndSettle();
    expect(verify(mockAccountBloc.add(LogOutAll())).callCount, 1);
  });

  testWidgets('MenuDrawer: import phrase gesture', (WidgetTester tester) async {
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
          child: MenuDrawer(
            user: userAccount,
            accounts: [userAccount],
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.text('importMnemonicPhrase'));
    await tester.pumpAndSettle();
    expect(
        verify(mockNavigatorBloc.add(NavigateToRecoverAccount())).callCount, 1);
  });

  testWidgets('MenuDrawer: import backup gesture', (WidgetTester tester) async {
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
          child: MenuDrawer(
            user: userAccount,
            accounts: [userAccount],
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.text('importMnemonicBackup'));
    await tester.pumpAndSettle();
    expect(
        verify(mockNavigatorBloc.add(NavigateToRestoreBackup())).callCount, 1);
  });
}
