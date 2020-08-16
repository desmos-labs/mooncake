import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:bloc_test/bloc_test.dart';

// mocks
class MockHomeBloc extends MockBloc<HomeEvent, HomeState> implements HomeBloc {}

class MockNavigatorBloc extends MockBloc<NavigatorEvent, NavigatorState>
    implements NavigatorBloc {}

class MockPostsListBloc extends MockBloc<PostsListEvent, PostsListState>
    implements PostsListBloc {}

class MockMnemonicBloc extends MockBloc<MnemonicEvent, MnemonicState>
    implements MnemonicBloc {}

class MockAccountBloc extends MockBloc<AccountEvent, AccountState>
    implements AccountBloc {}

class MockRecoverAccountBloc
    extends MockBloc<RecoverAccountEvent, RecoverAccountState>
    implements RecoverAccountBloc {}

class MockNotificationsBloc
    extends MockBloc<NotificationsEvent, NotificationsState>
    implements NotificationsBloc {}

class MockPostDetailsBloc extends MockBloc<PostDetailsEvent, PostDetailsState>
    implements PostDetailsBloc {}

/// widget wrapper to make testable
Widget makeTestableWidget({Widget child, theme = 'light'}) {
  return MediaQuery(
    data: MediaQueryData(),
    child: MaterialApp(
        themeMode: theme == 'light' ? ThemeMode.light : ThemeMode.dark,
        theme: PostsTheme.lightTheme,
        darkTheme: PostsTheme.darkTheme,
        localizationsDelegates: [
          PostsLocalizations.delegateTest,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en'), // English, no country code
        ],
        home: Scaffold(
          body: child,
        )),
  );
}
