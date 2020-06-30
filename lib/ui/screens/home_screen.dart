import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';

/// HomeScreen is the main screen of the application, and the one from which
/// the user can access the posts timeline as well as other screens by
/// using the navigation bar
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, AppTab>(
      builder: (context, activeTab) {
        Widget body = Container();
        if (activeTab == AppTab.home) {
          return Scaffold(
            body: Stack(
              children: [
                Column(
                  children: [
                    // should have widget here
                    postsAppBar(context),
                    Expanded(child: PostsList()),
                  ],
                ),
                MnemonicBackupPopup(),
              ],
            ),
            bottomNavigationBar: SafeArea(child: TabSelector()),
          );
        } else if (activeTab == AppTab.notifications) {
          body = NotificationsMainContent();
        } else if (activeTab == AppTab.account) {
          final state = BlocProvider.of<AccountBloc>(context).state;
          return UserDetailsScreen(
            isMyProfile: true,
            user: (state as LoggedIn).user,
          );
        }

        return Scaffold(
          appBar: activeTab == AppTab.home
              ? postsAppBar(context)
              : accountAppBar(context),
          body: body,
          bottomNavigationBar: SafeArea(child: TabSelector()),
        );
      },
    );
  }
}
