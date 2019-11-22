import 'package:desmosdemo/keys.dart';
import 'package:desmosdemo/localization.dart';
import 'package:desmosdemo/models/models.dart';
import 'package:desmosdemo/screens/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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
              ? FlutterBlocLocalizations.of(context).stats
              : FlutterBlocLocalizations.of(context).posts),
        );
      }).toList(),
    );
  }
}
