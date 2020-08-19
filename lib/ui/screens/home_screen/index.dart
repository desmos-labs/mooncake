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
          Widget body = Container();
          if (state.activeTab == AppTab.home) {
            final accountState = BlocProvider.of<AccountBloc>(context).state;
            return Scaffold(
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
            );
          } else if (state.activeTab == AppTab.notifications) {
            body = NotificationsMainContent();
          } else if (state.activeTab == AppTab.account) {
            final state = BlocProvider.of<AccountBloc>(context).state;
            return UserDetailsScreen(
              isMyProfile: true,
              user: (state as LoggedIn).user,
            );
          }

          return Scaffold(
            appBar: state.activeTab == AppTab.home
                ? postsAppBar(context)
                : accountAppBar(context),
            body: body,
            bottomNavigationBar: SafeArea(child: TabSelector()),
          );
        },
      ),
    );
  }
}
