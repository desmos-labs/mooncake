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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(color: PostsTheme.borderColor, width: 0.5 ),
        )
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        key: PostsKeys.tabs,
        children: [
          _barItem(
            PostsKeys.allPostsTab,
            FontAwesomeIcons.list,
            PostsLocalizations.of(context).allPosts,
          ),
          _barItem(
            PostsKeys.likedPostsTab,
            FontAwesomeIcons.heart,
            PostsLocalizations.of(context).likedPosts,
          ),
          MaterialButton(
            textColor: Colors.white,
            padding: EdgeInsets.all(0),
            onPressed: (){},
            shape: CircleBorder(),
            child: Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: PostsTheme.gradient,
              ),
              child: Icon(FontAwesomeIcons.plus),
            ),
          ),
          _barItem(
            PostsKeys.yourPostsTab,
            FontAwesomeIcons.userAlt,
            PostsLocalizations.of(context).yourAccount,
          ),
          _barItem(
            PostsKeys.notificationsTab,
            FontAwesomeIcons.bell,
            PostsLocalizations.of(context).notifications,
          ),
        ],
      ),
    );
  }

  Widget _barItem(Key key, IconData icon, String title) {
    return IconButton(
      onPressed: () {},
      icon: ShaderMask(
        shaderCallback: (Rect bounds) {
          return PostsTheme.gradient.createShader(bounds);
        },
        child: Icon(icon, key: key),
      ),
    );
  }
}
