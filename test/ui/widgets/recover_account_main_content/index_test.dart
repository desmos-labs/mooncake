import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/ui/ui.dart';
import '../../helper.dart';
import 'package:mooncake/ui/widgets/recover_account_main_content/widgets/export.dart';

void main() {
  testWidgets('RecoverAccountMainContent: Displays export correctly',
      (WidgetTester tester) async {
    var mockRecoverAccountBloc = MockRecoverAccountBloc();
    when(mockRecoverAccountBloc.state)
        .thenReturn(RecoverAccountState.initial());

    var backupPhrase = false;
    await tester.pumpWidget(
      makeTestableWidget(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<RecoverAccountBloc>(
                create: (_) => mockRecoverAccountBloc),
          ],
          child: RecoverAccountMainContent(
            bottomPadding: 10.0,
            backupPhrase: backupPhrase,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('recoverAccountContinueButton'), findsNWidgets(2));
    expect(find.byType(MnemonicInputItem), findsWidgets);
  });

  testWidgets('RecoverAccountMainContent: Displays export correctly 2',
      (WidgetTester tester) async {
    var mockRecoverAccountBloc = MockRecoverAccountBloc();
    var mockNavigatorBloc = MockNavigatorBloc();
    when(mockRecoverAccountBloc.state).thenReturn(
      RecoverAccountState(
        currentWordIndex: 0,
        wordsList: List(24),
        isMnemonicValid: true,
      ),
    );

    var backupPhrase = false;
    await tester.pumpWidget(
      makeTestableWidget(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<RecoverAccountBloc>(
                create: (_) => mockRecoverAccountBloc),
            BlocProvider<NavigatorBloc>(create: (_) => mockNavigatorBloc),
          ],
          child: RecoverAccountMainContent(
            bottomPadding: 10.0,
            backupPhrase: backupPhrase,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.byType(PrimaryButton).last);
    await tester.pumpAndSettle();
    expect(
        verify(mockRecoverAccountBloc.add(TurnOffBackupPopup())).callCount, 1);
    expect(
        verify(mockNavigatorBloc.add(NavigateToProtectAccount())).callCount, 1);
  });
}
