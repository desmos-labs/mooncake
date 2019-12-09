import 'package:desmosdemo/entities/entities.dart';
import 'package:desmosdemo/ui/keys/export.dart';
import 'package:desmosdemo/ui/localization/export.dart';
import 'package:desmosdemo/ui/ui.dart';
import 'package:flutter/material.dart';

/// Allows the user to select which tab should be visible inside
/// the [HomeScreen].
class TabSelector extends StatelessWidget {
  final AppTab activeTab;
  final Function(AppTab) onTabSelected;

  TabSelector({
    Key key,
    @required this.activeTab,
    @required this.onTabSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      key: PostsKeys.tabs,
      currentIndex: AppTab.values.indexOf(activeTab),
      onTap: (index) => onTabSelected(AppTab.values[index]),
      items: AppTab.values.map((tab) {
        return BottomNavigationBarItem(
          icon: Icon(
            tab == AppTab.posts
                ? FontAwesomeIcons.diceD6
                : FontAwesomeIcons.database,
            key: tab == AppTab.posts
                ? PostsKeys.chainPostsTab
                : PostsKeys.localPostsStab,
          ),
          title: Text(tab == AppTab.posts
              ? PostsLocalizations.of(context).onChainPosts
              : PostsLocalizations.of(context).offChainPosts),
        );
      }).toList(),
    );
  }
}
