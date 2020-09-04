import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/ui/ui.dart';
import '../../../../helper.dart';
import 'package:mooncake/ui/screens/login_screen/widgets/export.dart';
import 'package:mockito/mockito.dart';

void main() {
  testWidgets('CreatingAccountPopupContent: Displays correctly',
      (WidgetTester tester) async {
    var mockAccountBloc = MockAccountBloc();
    await tester.pumpWidget(
      makeTestableWidget(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<AccountBloc>(
              create: (_) => mockAccountBloc,
            ),
          ],
          child: CreatingAccountPopupContent(),
        ),
      ),
    );

    await tester.pump(const Duration(seconds: 3));

    expect(find.byType(LoadingIndicator), findsOneWidget);
    expect(find.byType(SecondaryDarkButton), findsOneWidget);
    expect(find.byType(SizedBox), findsWidgets);
    expect(
      find.text(
        'creatingAccountPopupTitle'.toUpperCase(),
      ),
      findsOneWidget,
    );
    expect(
      find.text('creatingAccountText'),
      findsOneWidget,
    );

    await tester.tap(find.byType(SecondaryDarkButton));
    await tester.pump(const Duration(seconds: 3));
    expect(verify(mockAccountBloc.add(LogOutAll())).callCount, 1);
  });
}
