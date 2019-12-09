import 'package:desmosdemo/entities/entities.dart';
import 'package:desmosdemo/ui/keys/export.dart';
import 'package:desmosdemo/ui/localization/export.dart';
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
            tab == AppTab.posts ? Icons.list : Icons.show_chart,
            key: tab == AppTab.posts ? PostsKeys.postsTab : PostsKeys.statsTab,
          ),
          title: Text(tab == AppTab.stats
              ? PostsLocalizations.of(context).stats
              : PostsLocalizations.of(context).posts),
        );
      }).toList(),
    );
  }
}
