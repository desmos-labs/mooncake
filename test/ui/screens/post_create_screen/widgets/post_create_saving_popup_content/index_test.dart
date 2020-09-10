import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mooncake/ui/screens/post_create_screen/blocs/export.dart';
import 'package:mooncake/ui/screens/post_create_screen/widgets/export.dart';
import '../../../../../mocks/mocks.dart';
import '../../../../helper.dart';

class MockPostInputBloc extends MockBloc<PostInputState>
    implements PostInputBloc {}

void main() {
  testWidgets('PostSavingPopupContent: Displays correctly',
      (WidgetTester tester) async {
    var mockPostInputBloc = MockPostInputBloc();
    when(mockPostInputBloc.state).thenReturn(PostInputState.empty(testPost));

    await tester.pumpWidget(
      makeTestableWidget(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<PostInputBloc>(
              create: (_) => mockPostInputBloc,
            ),
          ],
          child: PostSavingPopupContent(),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('savingPostPopupBody'), findsOneWidget);
    expect(find.byType(PrimaryButton), findsOneWidget);
  });
}
