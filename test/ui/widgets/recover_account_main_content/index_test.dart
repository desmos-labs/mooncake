import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/ui/ui.dart';
import '../../helper.dart';
import 'package:mooncake/ui/widgets/recover_account_main_content/widgets/export.dart';

void main() {
  testWidgets('RecoverAccountMainContent: Displays export correctly',
      (WidgetTester tester) async {
    MockRecoverAccountBloc mockRecoverAccountBloc = MockRecoverAccountBloc();
    when(mockRecoverAccountBloc.state)
        .thenReturn(RecoverAccountState.initial());

    bool backupPhrase = false;
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
}
