import 'package:desmosdemo/widgets/widgets.dart';
import 'package:flutter/material.dart';

/// Represents a single option that can be tapped and is linked to a post.
/// It is represented by an icon and an optional text value put next to the
/// icon itself. When tapped it executes the given action.
class PostAction extends StatelessWidget {
  final IconData icon;
  final String value;
  final Function action;

  PostAction({
    @required this.icon,
    this.action,
    this.value,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        PostActionIcon(icon: icon, action: action),
        value != null ? SizedBox(width: 8) : null,
        value != null ? Text(value, style: TextStyle(fontSize: 12.0)) : null,
      ],
    );
  }
}
