import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import '../../../../helper.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mooncake/ui/screens/security_set_password_screen/blocs/export.dart';
import 'package:mooncake/ui/screens/security_set_password_screen/widgets/export.dart';
import 'package:mooncake/ui/screens/security_set_password_screen/widgets/set_password_content/widgets/export.dart';
import 'package:mooncake/ui/ui.dart';

class MockSetPasswordBloc extends MockBloc<SetPasswordState>
    implements SetPasswordBloc {}

void main() {
  testWidgets('SetBiometricTitle: Displays correctly',
      (WidgetTester tester) async {
    var mockSetPasswordBloc = MockSetPasswordBloc();

    when(mockSetPasswordBloc.state)
        .thenAnswer((_) => SetPasswordState.initial());

    await tester.pumpWidget(
      makeTestableWidget(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<SetPasswordBloc>(
              create: (_) => mockSetPasswordBloc,
            ),
          ],
          child: SetPasswordContent(),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byType(PasswordStrengthIndicator), findsOneWidget);
    expect(find.byType(PasswordInputField), findsOneWidget);
    expect(find.byType(PrimaryButton), findsOneWidget);
    expect(find.text('passwordCaption'), findsOneWidget);
    expect(find.text('passwordSaveButton'), findsOneWidget);
  });
}
