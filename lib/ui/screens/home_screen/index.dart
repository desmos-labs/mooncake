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
          AppTab selectedAppTab;
          bool backToTop = false;
          List<Widget> optimizedTabView;
          List<int> optimizedTabViewIndex;
          int tabIndex = 0;
          Map<AppTab, bool> originalDic = {
            AppTab.home: true,
            AppTab.account: false,
            AppTab.notifications: false,
          };

          const Map<AppTab, int> originalIndex = {
            AppTab.home: 0,
            AppTab.account: 1,
            AppTab.notifications: 2,
          };

          final accountState = BlocProvider.of<AccountBloc>(context).state;

          List<Widget> originalTabView = [
            // home
            Stack(
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
            int index = originalIndex[activeTab];
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

          _selectedTab(state.activeTab);

          // check if back to top is needed
          if (selectedAppTab == state.activeTab) {
            backToTop = true;
          }
          ;

          return Scaffold(
            // appBar: state.activeTab == AppTab.home
            //     ? postsAppBar(context)
            //     : accountAppBar(context),
            // body: body,
            body: IndexedStack(
                index: optimizedTabViewIndex.indexOf(tabIndex),
                children: optimizedTabView),
            bottomNavigationBar: SafeArea(child: TabSelector()),
          );
        },
      ),
    );
  }
}
