import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';
import 'widgets/export.dart';

/// HomeScreen is the main screen of the application, and the one from which
/// the user can access the posts timeline as well as other screens by
/// using the navigation bar
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc.create(context),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          List<Widget> optimizedTabView;
          List<int> optimizedTabViewIndex;
          var tabIndex = 0;
          // map of screens that has been loaded
          var originalDic = <AppTab, bool>{
            AppTab.home: true,
            AppTab.account: false,
            AppTab.notifications: false,
          };

          // map of screens position
          const originalIndex = <AppTab, int>{
            AppTab.home: 0,
            AppTab.account: 1,
            AppTab.notifications: 2,
          };

          final accountState = BlocProvider.of<AccountBloc>(context).state;

          var originalTabView = <Widget>[
            // home
            Scaffold(
              body: Stack(
                children: [
                  Column(
                    children: [
                      postsAppBar(context),
                      Expanded(
                          child: PostsList(
                        user: (accountState as LoggedIn).user,
                      )),
                    ],
                  ),
                  if (state.showBackupPhrasePopup) MnemonicBackupPopup(),
                ],
              ),
              bottomNavigationBar: SafeArea(child: TabSelector()),
            ),
            // account
            UserDetailsScreen(
              isMyProfile: true,
              user: (accountState as LoggedIn).user,
            ),
            // notification
            NotificationsMainContent(),
          ];

          optimizedTabView = [originalTabView.first];
          optimizedTabViewIndex = [0];

          void _selectedTab(AppTab activeTab) {
            var index = originalIndex[activeTab];
            if (originalDic[activeTab] == false) {
              optimizedTabViewIndex.add(index);
              originalDic[activeTab] = true;
              optimizedTabViewIndex.sort();
              optimizedTabView = optimizedTabViewIndex.map((index) {
                return originalTabView[index];
              }).toList();
            }

            tabIndex = index;
          }

          // load the screen if needed
          _selectedTab(state.activeTab);

          return IndexedStack(
            index: optimizedTabViewIndex.indexOf(tabIndex),
            children: optimizedTabView,
          );
        },
      ),
    );
  }
}
