import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/ui/ui.dart';
import '../../../../helper.dart';
import 'package:mooncake/ui/widgets/recover_account_main_content/widgets/export.dart';

void main() {
  testWidgets('MnemonicInputItem: Displays export correctly',
      (WidgetTester tester) async {
    var mockRecoverAccountBloc = MockRecoverAccountBloc();
    when(mockRecoverAccountBloc.state)
        .thenReturn(RecoverAccountState.initial());

    await tester.pumpWidget(
      makeTestableWidget(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<RecoverAccountBloc>(
                create: (_) => mockRecoverAccountBloc),
          ],
          child: MnemonicInputItem(index: 1),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(TextFormField), findsOneWidget);
    expect(tester.widget<SizedBox>(find.byType(SizedBox).first).width, 10);
  });
}
