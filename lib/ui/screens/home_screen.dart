import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/foundation.dart';
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
          body = PostsList();
        } else if (activeTab == AppTab.notifications) {
          body = NotificationsMainContent();
        } else if (activeTab == AppTab.account) {
          body = AccountScreenContent();
        }

        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              activeTab == AppTab.allPosts
                  ? PostsLocalizations.of(context).appName
                  : PostsLocalizations.of(context).accountScreenTitle,
            ),
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: Icon(Theme.of(context).brightness == Brightness.light
                  ? MooncakeIcons.lightbulb
                  : MooncakeIcons.lightbulbF),
              tooltip: PostsLocalizations.of(context).brightnessButtonTooltip,
              onPressed: () {
                DynamicTheme.of(context).setBrightness(
                    Theme.of(context).brightness == Brightness.dark
                        ? Brightness.light
                        : Brightness.dark);
              },
            ),
            actions: [
              if (kDebugMode)
                IconButton(
                  icon: Icon(MooncakeIcons.delete),
                  onPressed: () {
                    BlocProvider.of<PostsListBloc>(context).add(DeletePosts());
                  },
                ),
              IconButton(
                icon: Icon(MooncakeIcons.wallet),
                tooltip: PostsLocalizations.of(context).walletButtonTooltip,
                onPressed: () {
                  BlocProvider.of<NavigatorBloc>(context)
                      .add(NavigateToWallet());
                },
              ),
              IconButton(
                icon: Icon(MooncakeIcons.logout),
                tooltip: PostsLocalizations.of(context).logoutButtonTooltip,
                onPressed: () {
                  BlocProvider.of<AccountBloc>(context).add(LogOut());
                  BlocProvider.of<NavigatorBloc>(context).add(NavigateToHome());
                },
              ),
            ],
          ),
          body: body,
          bottomNavigationBar: SafeArea(child: TabSelector()),
        );
      },
    );
  }
}
