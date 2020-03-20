import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/entities/app/app_tab.dart';
import 'package:mooncake/ui/ui.dart';

import 'bottom_navigation_button.dart';

/// Allows the user to select which tab should be visible inside
/// the [HomeScreen].
class TabSelector extends StatelessWidget {
  TabSelector({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          border: Border(
            top: BorderSide(color: Colors.grey[500], width: 0.5),
          )),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        key: PostsKeys.tabs,
        children: [
          BottomNavigationButton(
            key: PostsKeys.allPostsTab,
            tab: AppTab.allPosts,
          ),
          MaterialButton(
            textColor: Colors.white,
            padding: EdgeInsets.all(0),
            onPressed: () => _createRoute(context),
            shape: CircleBorder(),
            child: Container(
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: ThemeColors.gradient,
              ),
              child: Icon(MooncakeIcons.addPost, size: 48),
            ),
          ),
          BottomNavigationButton(
            key: PostsKeys.notificationsTab,
            tab: AppTab.account,
          ),
        ],
      ),
    );
  }

  void _createRoute(BuildContext context) {
    BlocProvider.of<NavigatorBloc>(context).add(NavigateToCreatePost());
  }
}
