import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/localization/export.dart';
import 'package:mooncake/ui/ui.dart';

/// Represents a button that is shown inside the bottom navigation bar allowing
/// to show a specific tab of the application.
class BottomNavigationButton extends StatelessWidget {
  final AppTab tab;

  const BottomNavigationButton({Key key, this.tab}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final titles = {
      AppTab.allPosts: PostsLocalizations.of(context).allPostsTabTitle,
      AppTab.likedPosts: PostsLocalizations.of(context).likedPostsTabTitle,
      AppTab.notifications:
          PostsLocalizations.of(context).notificationsTabTitle,
      AppTab.account: PostsLocalizations.of(context).yourAccountTabTitle,
    };

    final icons = {
      AppTab.allPosts: MooncakeIcons.home,
      AppTab.likedPosts: MooncakeIcons.heart,
      AppTab.notifications: MooncakeIcons.bell,
      AppTab.account: MooncakeIcons.user,
    };

    final selectedIcons = {
      AppTab.allPosts: MooncakeIcons.homeFilled,
      AppTab.likedPosts: MooncakeIcons.heartFilled,
      AppTab.notifications: MooncakeIcons.bellFilled,
      AppTab.account: MooncakeIcons.userFilled,
    };

    return BlocBuilder<HomeBloc, AppTab>(
      builder: (context, currentTab) {
        return IconButton(
          tooltip: titles[tab],
          onPressed: () => _showTab(context),
          icon: tab != currentTab
              ? Icon(icons[tab], key: key)
              : Icon(selectedIcons[tab], key: key)
        );
      },
    );
  }

  void _showTab(BuildContext context) {
    BlocProvider.of<HomeBloc>(context).add(UpdateTab(tab));
  }
}
