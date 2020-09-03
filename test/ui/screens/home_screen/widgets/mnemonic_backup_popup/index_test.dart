import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:mooncake/ui/ui.dart';
import '../../../../helper.dart';
import 'package:mooncake/ui/screens/home_screen/widgets/export.dart';

void main() {
  testWidgets('MnemonicBackupPopup: Displays export correctly',
      (WidgetTester tester) async {
    var mockNavigatorBloc = MockNavigatorBloc();
    var mockHomeBloc = MockHomeBloc();

    await tester.pumpWidget(
      makeTestableWidget(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<NavigatorBloc>(create: (_) => mockNavigatorBloc),
            BlocProvider<HomeBloc>(create: (_) => mockHomeBloc),
          ],
          child: MnemonicBackupPopup(),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byType(GenericPopup), findsOneWidget);
    expect(find.byType(PrimaryButton), findsOneWidget);
    expect(find.byType(SecondaryDarkButton), findsOneWidget);
    expect(find.byType(GestureDetector), findsWidgets);
    expect(find.text('mnemonicDoNotShowAgainButton'), findsOneWidget);
  });
}
