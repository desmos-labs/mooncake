import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/ui/ui.dart';
import '../../helper.dart';

void main() {
  testWidgets('ExportMnemonicPopup: Displays correctly',
      (WidgetTester tester) async {
    var mockMnemonicBloc = MockMnemonicBloc();
    when(mockMnemonicBloc.state).thenReturn(
      ExportingMnemonic.fromMnemonicState(
        MnemonicState.initial(),
      ),
    );

    await tester.pumpWidget(
      makeTestableWidget(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<MnemonicBloc>(
              create: (_) => mockMnemonicBloc,
            ),
          ],
          child: ExportMnemonicPopup(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(GenericPopup), findsOneWidget);
    expect(find.byType(Column), findsOneWidget);
    expect(find.byType(SecondaryDarkButton), findsOneWidget);
  });
}
