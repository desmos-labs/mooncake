import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter/material.dart';
import '../../../../../../helper.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:mooncake/ui/screens/security_set_password_screen/blocs/export.dart';
import 'package:mooncake/ui/screens/security_set_password_screen/widgets/set_password_content/widgets/export.dart';

class MockSetPasswordBloc extends MockBloc<SetPasswordState>
    implements SetPasswordBloc {}

void main() {
  testWidgets('PasswordInputField: Displays correctly',
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
          child: PasswordInputField(),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byType(TextFormField), findsOneWidget);
    expect(find.byIcon(MooncakeIcons.eye), findsOneWidget);

    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle();
    expect(
        verify(mockSetPasswordBloc.add(TriggerPasswordVisibility())).callCount,
        1);
  });
}
