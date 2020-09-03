import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/ui/ui.dart';
import '../../helper.dart';
import 'package:flutter/material.dart';

void main() {
  var mockRecoverAccountBloc = MockRecoverAccountBloc();
  testWidgets('PostDetailsScreen: Displays correctly',
      (WidgetTester tester) async {
    when(mockRecoverAccountBloc.state)
        .thenReturn(RecoverAccountState.initial());

    await tester.pumpWidget(
      makeTestableWidget(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<RecoverAccountBloc>(
              create: (_) => mockRecoverAccountBloc,
            ),
          ],
          child: RecoverAccountScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(RecoverAccountMainContent), findsOneWidget);
    expect(find.byType(RecoverAccountWordsList), findsOneWidget);
    expect(find.text('recoverScreenTitle'), findsOneWidget);
  });
}
