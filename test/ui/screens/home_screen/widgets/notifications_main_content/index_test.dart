import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/ui/ui.dart';
import '../../../../helper.dart';
import 'package:mooncake/ui/screens/home_screen/widgets/export.dart';
import 'package:mooncake/ui/screens/home_screen/widgets/notifications_main_content/widgets/export.dart';

void main() {
  testWidgets('NotificationsMainContent: Displays export correctly',
      (WidgetTester tester) async {
    var mockAccountBloc = MockAccountBloc();
    var mockNotificationsBloc = MockNotificationsBloc();

    when(mockNotificationsBloc.state).thenReturn(NotificationsLoaded([]));

    await tester.pumpWidget(
      makeTestableWidget(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<NotificationsBloc>(
                create: (_) => mockNotificationsBloc),
            BlocProvider<AccountBloc>(create: (_) => mockAccountBloc),
          ],
          child: NotificationsMainContent(),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byType(TabBar), findsOneWidget);
    expect(find.byType(NotificationsList), findsOneWidget);
    expect(find.text('noNotifications'), findsOneWidget);
  });
}
