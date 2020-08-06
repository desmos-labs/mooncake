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
      AppTab.home:
          PostsLocalizations.of(context).translate(Messages.allPostsTabTitle),
      AppTab.likedPosts:
          PostsLocalizations.of(context).translate(Messages.likedPostsTabTitle),
      AppTab.notifications: PostsLocalizations.of(context)
          .translate(Messages.notificationsTabTitle),
      AppTab.account: PostsLocalizations.of(context)
          .translate(Messages.yourAccountTabTitle),
    };

    final icons = {
      AppTab.home: MooncakeIcons.home,
      AppTab.likedPosts: MooncakeIcons.heart,
      AppTab.notifications: MooncakeIcons.bell,
      AppTab.account: MooncakeIcons.user,
    };

    final selectedIcons = {
      AppTab.home: MooncakeIcons.homeF,
      AppTab.likedPosts: MooncakeIcons.heartF,
      AppTab.notifications: MooncakeIcons.bellF,
      AppTab.account: MooncakeIcons.userF,
    };

    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final isSelected = tab == state.activeTab;
        return IconButton(
          tooltip: titles[tab],
          onPressed: () => _showTab(context),
          color: isSelected ? Theme.of(context).colorScheme.primary : null,
          icon: isSelected
              ? Icon(selectedIcons[tab], key: key)
              : Icon(icons[tab], key: key),
        );
      },
    );
  }

  void _showTab(BuildContext context) {
    BlocProvider.of<HomeBloc>(context).add(UpdateTab(tab));
  }
}
