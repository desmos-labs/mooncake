import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:bloc_test/bloc_test.dart';

// mocks
class MockHomeBloc extends MockBloc<HomeState> implements HomeBloc {}

class MockNavigatorBloc extends MockBloc<NavigatorState>
    implements NavigatorBloc {}

class MockPostsListBloc extends MockBloc<PostsListState>
    implements PostsListBloc {}

class MockMnemonicBloc extends MockBloc<MnemonicState> implements MnemonicBloc {
}

class MockAccountBloc extends MockBloc<AccountState> implements AccountBloc {}

class MockRecoverAccountBloc extends MockBloc<RecoverAccountState>
    implements RecoverAccountBloc {}

class MockNotificationsBloc extends MockBloc<NotificationsState>
    implements NotificationsBloc {}

class MockPostDetailsBloc extends MockBloc<PostDetailsState>
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
