import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:mooncake/ui/widgets/mnemonic_visualizer/widgets/export.dart';
import '../../../../helper.dart';

void main() {
  var mockMnemonicBloc = MockMnemonicBloc();
  testWidgets('BackupMnemonicButton: Displays correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      makeTestableWidget(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<MnemonicBloc>(
              create: (_) => mockMnemonicBloc,
            ),
          ],
          child: makeTestableWidget(
            child: Container(
              child: Row(
                children: [ExportMnemonicButton()],
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(Expanded), findsOneWidget);
    expect(find.byType(PrimaryButton), findsOneWidget);
    expect(find.text('exportMnemonic'), findsOneWidget);
  });
}
