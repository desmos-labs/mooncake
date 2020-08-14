import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:mooncake/ui/widgets/post_item_header/widgets/post_more_button/widgets/dialogs/blocs/export.dart';
import 'package:mooncake/ui/widgets/post_item_header/widgets/post_more_button/widgets/export.dart';
import '../../../../../../helper.dart';

class MockReportPopupBloc extends MockBloc<ReportPopupEvent, ReportPopupState>
    implements ReportPopupBloc {}

MooncakeAccount userAccount = MooncakeAccount(
  profilePicUri: "https://example.com/avatar.png",
  moniker: "john-doe",
  cosmosAccount: CosmosAccount(
    accountNumber: 153,
    address: "desmos1ew60ztvqxlf5kjjyyzxf7hummlwdadgesu3725",
    coins: [
      StdCoin(amount: "10000", denom: "udaric"),
    ],
    sequence: 45,
  ),
);

void main() {
  testWidgets('BlocUserDialog: Displays export correctly',
      (WidgetTester tester) async {
    MockReportPopupBloc mockReportPopupBloc = MockReportPopupBloc();
    MockNavigatorBloc mockNavigatorBloc = MockNavigatorBloc();
    MockPostsListBloc mockPostsListBloc = MockPostsListBloc();

    when(mockReportPopupBloc.state).thenReturn(ReportPopupState.initial());

    await tester.pumpWidget(
      makeTestableWidget(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<ReportPopupBloc>(
              create: (_) => mockReportPopupBloc,
            ),
            BlocProvider<NavigatorBloc>(
              create: (_) => mockNavigatorBloc,
            ),
            BlocProvider<PostsListBloc>(
              create: (_) => mockPostsListBloc,
            ),
          ],
          child: BlocUserDialog(user: userAccount),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('blockDialogTitle'), findsOneWidget);
    expect(find.text('blockDialogCancelButton'), findsOneWidget);
    expect(find.text('blockDialogBlockButton'), findsOneWidget);
    await tester.tap(find.text('blockDialogBlockButton'));
    await tester.pumpAndSettle();
    expect(verify(mockPostsListBloc.add(any)).callCount, 1);
    expect(find.text('blockDialogTitle'), findsNothing);
    expect(find.text('blockDialogCancelButton'), findsNothing);
    expect(find.text('blockDialogBlockButton'), findsNothing);
  });

  testWidgets('BlocUserDialog: Displays cancel correctly',
      (WidgetTester tester) async {
    MockReportPopupBloc mockReportPopupBloc = MockReportPopupBloc();
    MockNavigatorBloc mockNavigatorBloc = MockNavigatorBloc();
    MockPostsListBloc mockPostsListBloc = MockPostsListBloc();

    when(mockReportPopupBloc.state).thenReturn(ReportPopupState.initial());

    await tester.pumpWidget(
      makeTestableWidget(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<ReportPopupBloc>(
              create: (_) => mockReportPopupBloc,
            ),
            BlocProvider<NavigatorBloc>(
              create: (_) => mockNavigatorBloc,
            ),
            BlocProvider<PostsListBloc>(
              create: (_) => mockPostsListBloc,
            ),
          ],
          child: BlocUserDialog(user: userAccount),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('blockDialogTitle'), findsOneWidget);
    expect(find.text('blockDialogCancelButton'), findsOneWidget);
    expect(find.text('blockDialogBlockButton'), findsOneWidget);

    await tester.tap(find.text('blockDialogCancelButton'));
    await tester.pumpAndSettle();
    expect(find.text('blockDialogTitle'), findsNothing);
    expect(find.text('blockDialogCancelButton'), findsNothing);
    expect(find.text('blockDialogBlockButton'), findsNothing);
  });
}
