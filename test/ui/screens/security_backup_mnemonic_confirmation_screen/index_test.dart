import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/ui/ui.dart';
import '../../helper.dart';

void main() {
  var mockRecoverAccountBloc = MockRecoverAccountBloc();
  testWidgets('BackupMnemonicConfirmationScreen: Displays correctly',
      (WidgetTester tester) async {
    when(mockRecoverAccountBloc.state)
        .thenReturn(RecoverAccountState.initial());

    await tester.pumpWidget(
      makeTestableWidget(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<RecoverAccountBloc>(
              create: (_) => mockRecoverAccountBloc,
            ),
          ],
          child: BackupMnemonicConfirmationScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byType(RecoverAccountMainContent), findsOneWidget);
    expect(find.byType(RecoverAccountWordsList), findsOneWidget);
    expect(find.text('mnemonicConfirmPhrase'), findsOneWidget);
  });
}
