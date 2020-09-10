import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:bloc_test/bloc_test.dart';
import '../../../../helper.dart';
import 'package:mooncake/ui/screens/post_create_screen/blocs/export.dart';
import 'package:mooncake/ui/screens/post_create_screen/widgets/export.dart';
import '../../../../../mocks/mocks.dart';

class MockPostInputBloc extends MockBloc<PostInputState>
    implements PostInputBloc {}

void main() {
  testWidgets('PostCreateActions: Displays correctly',
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
          child: PostCreateActions(height: 300),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byIcon(MooncakeIcons.poll), findsOneWidget);

    await tester.tap(find.byIcon(MooncakeIcons.poll));
    await tester.pumpAndSettle();
    expect(verify(mockPostInputBloc.add(any)).callCount, 1);
  });
}
