import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/ui/ui.dart';
import '../../helper.dart';

void main() {
  testWidgets('RecoverAccountWordsList: Displays export correctly',
      (WidgetTester tester) async {
    var mockRecoverAccountBloc = MockRecoverAccountBloc();
    when(mockRecoverAccountBloc.state)
        .thenReturn(RecoverAccountState.initial());

    await tester.pumpWidget(
      makeTestableWidget(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<RecoverAccountBloc>(
                create: (_) => mockRecoverAccountBloc),
          ],
          child: RecoverAccountWordsList(
            height: 40,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byType(ActionChip), findsWidgets);
  });
}
