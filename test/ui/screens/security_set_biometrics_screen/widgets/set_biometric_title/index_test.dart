import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter/material.dart';
import '../../../../helper.dart';
import 'package:mooncake/ui/screens/security_set_biometrics_screen/widgets/export.dart';
import 'package:mooncake/ui/screens/security_set_biometrics_screen/blocs/export.dart';
import 'package:bloc_test/bloc_test.dart';

class MockBiometricsBloc extends MockBloc<BiometricsState>
    implements BiometricsBloc {}

void main() {
  testWidgets('SetBiometricTitle: Displays correctly',
      (WidgetTester tester) async {
    var mockBiometricsBloc = MockBiometricsBloc();
    when(mockBiometricsBloc.state).thenAnswer((_) => BiometricsState.initial());

    await tester.pumpWidget(
      makeTestableWidget(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<BiometricsBloc>(
              create: (_) => mockBiometricsBloc,
            ),
          ],
          child: SetBiometricTitle(),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byType(Icon), findsOneWidget);
    expect(find.text('biometricsTitle'), findsOneWidget);
  });
}
