import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:mooncake/ui/widgets/post_item_header/widgets/post_more_button/widgets/dialogs/widgets/popup_report/widgets/popup_report_option/index.dart';
import 'package:mooncake/ui/widgets/post_item_header/widgets/post_more_button/widgets/dialogs/widgets/export.dart';
import 'package:mooncake/ui/widgets/post_item_header/widgets/post_more_button/widgets/dialogs/blocs/export.dart';
import '../../../../../../../../helper.dart';
import '../../../../../../../../../mocks/posts.dart';

class MockReportPopupBloc extends MockBloc<ReportPopupState>
    implements ReportPopupBloc {}

void main() {
  testWidgets('PostListItem: Displays export correctly',
      (WidgetTester tester) async {
    var mockReportPopupBloc = MockReportPopupBloc();
    var mockNavigatorBloc = MockNavigatorBloc();
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
          ],
          child: ReportPostPopup(post: testPost),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(TextFormField), findsWidgets);
    expect(find.byType(CheckBoxButton), findsWidgets);
    expect(find.byType(PopupReportOption), findsWidgets);
    expect(find.text('reportPopupTitle'), findsOneWidget);
    expect(find.text('reportPopupSubmit'), findsOneWidget);
    expect(find.text('reportPopupSpam'), findsOneWidget);
    expect(find.text('reportPopupSexuallyInappropriate'), findsOneWidget);
    expect(find.text('reportPopupScamMisleading'), findsOneWidget);
    expect(find.text('reportPopupViolentProhibited'), findsOneWidget);
    expect(find.text('reportPopupOther'), findsOneWidget);
    expect(find.text('reportAndBlock'), findsOneWidget);

    await tester.tap(find.byType(PrimaryButton));
    await tester.pumpAndSettle();
    expect(verify(mockReportPopupBloc.add(SubmitReport())).callCount, 1);
    expect(verify(mockNavigatorBloc.add(GoBack())).callCount, 1);

    await tester.tap(find.text('reportPopupOther'));
    await tester.pumpAndSettle();
    expect(verify(mockReportPopupBloc.add(any)).callCount, 1);
  });
}
