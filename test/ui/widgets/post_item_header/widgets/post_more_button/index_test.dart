import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:mooncake/ui/widgets/post_item_header/widgets/export.dart';
import 'package:mooncake/ui/widgets/post_item_header/widgets/post_more_button/widgets/dialogs/blocs/export.dart';
import 'package:mooncake/ui/widgets/post_item_header/widgets/post_more_button/widgets/export.dart';

import '../../../../../mocks/mocks.dart';
import '../../../../helper.dart';

class MockReportPopupBloc extends MockBloc<ReportPopupState>
    implements ReportPopupBloc {}

MooncakeAccount userAccount = MooncakeAccount(
  profilePicUri: 'https://example.com/avatar.png',
  moniker: 'john-doe',
  cosmosAccount: cosmosAccount,
);

void main() {
  testWidgets('PostMoreButton: Displays export correctly',
      (WidgetTester tester) async {
    var mockReportPopupBloc = MockReportPopupBloc();
    var mockPostsListBloc = MockPostsListBloc();

    when(mockReportPopupBloc.state).thenReturn(ReportPopupState.initial());

    await tester.pumpWidget(
      makeTestableWidget(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<ReportPopupBloc>(
              create: (_) => mockReportPopupBloc,
            ),
            BlocProvider<PostsListBloc>(
              create: (_) => mockPostsListBloc,
            ),
          ],
          child: PostMoreButton(post: testPost),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byIcon(MooncakeIcons.more), findsOneWidget);
    expect(find.byIcon(MooncakeIcons.report), findsNothing);

    await tester.tap(find.byIcon(MooncakeIcons.more));
    await tester.pumpAndSettle();
    expect(find.byIcon(MooncakeIcons.report), findsOneWidget);
    expect(find.byIcon(MooncakeIcons.eyeClose), findsOneWidget);
    expect(find.byIcon(MooncakeIcons.block), findsOneWidget);
    expect(find.text('postActionReportPost'), findsOneWidget);
    expect(find.text('postActionHide'), findsOneWidget);
    expect(find.text('postActionBlockUser'), findsOneWidget);

    await tester.tap(find.text('postActionHide'));
    await tester.pumpAndSettle();
    expect(verify(mockPostsListBloc.add(any)).callCount, 1);
  });

  testWidgets('PostMoreButton: Displays onClicks correctly',
      (WidgetTester tester) async {
    var mockReportPopupBloc = MockReportPopupBloc();
    var mockPostsListBloc = MockPostsListBloc();

    when(mockReportPopupBloc.state).thenReturn(ReportPopupState.initial());

    await tester.pumpWidget(
      makeTestableWidget(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<ReportPopupBloc>(
              create: (_) => mockReportPopupBloc,
            ),
            BlocProvider<PostsListBloc>(
              create: (_) => mockPostsListBloc,
            ),
          ],
          child: PostMoreButton(post: testPost),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(MooncakeIcons.more));
    await tester.pumpAndSettle();

    await tester.tap(find.text('postActionBlockUser'));
    await tester.pumpAndSettle();
    expect(find.byType(BlocUserDialog), findsOneWidget);
  });
}
