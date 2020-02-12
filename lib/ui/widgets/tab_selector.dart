import 'package:flutter/material.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/keys/export.dart';
import 'package:mooncake/ui/localization/export.dart';
import 'package:mooncake/ui/ui.dart';

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
                ? FontAwesomeIcons.list
                : FontAwesomeIcons.userAlt,
            key: tab == AppTab.posts
                ? PostsKeys.allPostsTab
                : PostsKeys.yourPostsTab,
          ),
          title: Text(tab == AppTab.posts
              ? PostsLocalizations.of(context).allPosts
              : PostsLocalizations.of(context).yourAccount),
        );
      }).toList(),
    );
  }
}
