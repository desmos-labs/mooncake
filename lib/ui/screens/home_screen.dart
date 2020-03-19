import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';

/// HomeScreen is the main screen of the application, and the one from which
/// the user can access the posts timeline as well as other screens by
/// using the navigation bar
class HomeScreen extends StatelessWidget {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

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
          key: _scaffoldKey,
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              activeTab == AppTab.allPosts
                  ? PostsLocalizations.of(context).appName
                  : PostsLocalizations.of(context).accountScreenTitle,
            ),
            backgroundColor: Colors.transparent,
            textTheme: Theme.of(context).textTheme.copyWith(
                  headline6: Theme.of(context).textTheme.headline6.copyWith(
                        color: Theme.of(context).accentColor,
                      ),
                ),
            leading: IconButton(
              icon: Icon(Theme.of(context).brightness == Brightness.light
                  ? MooncakeIcons.lightBulb
                  : MooncakeIcons.lightBulbFilled),
              color: Theme.of(context).accentColor,
              onPressed: () {
                DynamicTheme.of(context).setBrightness(
                    Theme.of(context).brightness == Brightness.dark
                        ? Brightness.light
                        : Brightness.dark);
              },
            ),
            actions: [
              IconButton(
                color: Theme.of(context).accentColor,
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
