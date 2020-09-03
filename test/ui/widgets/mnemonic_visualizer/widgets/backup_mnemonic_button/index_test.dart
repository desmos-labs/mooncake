import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:mooncake/ui/widgets/mnemonic_visualizer/widgets/export.dart';
import '../../../../helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  var mockNavigatorBloc = MockNavigatorBloc();
  testWidgets('BackupMnemonicButton: Displays correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      makeTestableWidget(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<NavigatorBloc>(
              create: (_) => mockNavigatorBloc,
            ),
          ],
          child: makeTestableWidget(
            child: Container(
              child: Row(
                children: [BackupMnemonicButton()],
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(PrimaryButton), findsOneWidget);
    expect(
      tester
          .widget<Text>(
            find.descendant(
              of: find.byType(Padding).last,
              matching: find.byType(Text),
            ),
          )
          .style
          .fontSize,
      12,
    );
  });
}
