import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/ui/ui.dart';
import '../../../../helper.dart';
import 'package:mooncake/ui/screens/login_screen/widgets/export.dart';

void main() {
  testWidgets('AccountCreatedPopupContent: Displays correctly',
      (WidgetTester tester) async {
    var mockNavigatorBloc = MockNavigatorBloc();

    await tester.pumpWidget(
      makeTestableWidget(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<NavigatorBloc>(
              create: (_) => mockNavigatorBloc,
            ),
          ],
          child: AccountCreatedPopupContent(),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byType(PrimaryButton), findsOneWidget);
    expect(
        find.text(
          'accountCreatedPopupTitleFirstRow'.toUpperCase(),
        ),
        findsOneWidget);

    await tester.tap(find.byType(PrimaryButton));
    await tester.pumpAndSettle();
    expect(verify(mockNavigatorBloc.add(any)).callCount, 1);
  });
}
