import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../../helper.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mooncake/ui/screens/security_set_password_screen/blocs/export.dart';
import 'package:mooncake/ui/ui.dart';

class MockSetPasswordBloc extends MockBloc<SetPasswordState>
    implements SetPasswordBloc {}

void main() {
  testWidgets('SplashScreen: Displays correctly', (WidgetTester tester) async {
    var mockAccountBloc = MockAccountBloc();

    await tester.pumpWidget(
      makeTestableWidget(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<AccountBloc>(
              create: (_) => mockAccountBloc,
            ),
          ],
          child: SplashScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byType(Column), findsOneWidget);
    expect(find.text('appName'), findsOneWidget);
  });
}
