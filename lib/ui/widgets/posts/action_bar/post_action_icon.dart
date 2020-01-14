import 'package:mooncake/ui/ui.dart';
import 'package:flutter/material.dart';

/// Represents an icon of a post action, that changes color when tapped
/// and resets when not tapped anymore.
/// Also, when the taps wins, it executes the action.
class PostActionIcon extends StatefulWidget {
  final IconData icon;
  final Function action;

  const PostActionIcon({
    Key key,
    @required this.icon,
    @required this.action,
  }) : super(key: key);

  @override
  _PostActionIconState createState() => _PostActionIconState();
}

class _PostActionIconState extends State<PostActionIcon> {
  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    Color iconColor = Theme.of(context).iconTheme.color;
    if (isSelected) {
      iconColor = PostsTheme.primaryColor;
    } else if (widget.action != null) {
      iconColor = PostsTheme.accentColor;
    }

    final icon = Icon(this.widget.icon, size: 16, color: iconColor);
    return this.widget.action == null
        ? icon
        : GestureDetector(
            onTap: this.widget.action,
            onTapDown: (_) => setState(() {
              isSelected = true;
            }),
            onTapUp: (_) => setState(() {
              isSelected = false;
            }),
            onTapCancel: () => setState(() {
              isSelected = false;
            }),
            child: icon,
          );
  }
}
