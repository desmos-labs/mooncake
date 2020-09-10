import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter/material.dart';
import '../../../../../../helper.dart';
import 'package:mooncake/ui/screens/user_account_edit_screen/widgets/account_edit_body/widgets/export.dart';
import 'package:mooncake/ui/screens/user_account_edit_screen/blocs/edit/export.dart';
import 'package:bloc_test/bloc_test.dart';

class MockEditAccountBloc extends MockBloc<EditAccountState>
    implements EditAccountBloc {}

void main() {
  testWidgets('SetBiometricTitle: Displays correctly',
      (WidgetTester tester) async {
    var mockEditAccountBloc = MockEditAccountBloc();

    await tester.pumpWidget(
      makeTestableWidget(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<EditAccountBloc>(
              create: (_) => mockEditAccountBloc,
            ),
          ],
          child: AccountEditErrorPopup(error: 'Error'),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('saveAccountErrorPopupBody'), findsOneWidget);
    expect(find.text('dismiss'), findsOneWidget);

    await tester.tap(find.byType(FlatButton));
    await tester.pumpAndSettle();
    expect(verify(mockEditAccountBloc.add(HideErrorPopup())).callCount, 1);
  });
}
