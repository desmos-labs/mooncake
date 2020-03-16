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
        if (activeTab == AppTab.allPosts) {
          body = PostsList(filter: (p) => !p.hasParent);
        } else if (activeTab == AppTab.notifications) {
          body = NotificationsMainContent();
        } else if (activeTab == AppTab.account) {
          body = AccountScreenContent();
        }

        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(PostsLocalizations.of(context).appTitle),
            backgroundColor: Colors.transparent,
            textTheme: Theme.of(context).textTheme.copyWith(
                  headline6: Theme.of(context).textTheme.headline6.copyWith(
                        color: ThemeColors.accentColor,
                      ),
                ),
            actions: [
              IconButton(
                color: ThemeColors.accentColor,
                icon: Icon(MooncakeIcons.wallet),
                onPressed: () {
                  BlocProvider.of<NavigatorBloc>(context)
                      .add(NavigateToWallet());
                },
              )
            ],
          ),
          body: body,
          bottomNavigationBar: TabSelector(),
        );
      },
    );
  }
}
