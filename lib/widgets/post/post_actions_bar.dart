import 'package:desmosdemo/widgets/post/post_action_icon.dart';
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
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          children: <Widget>[
            PostActionIcon(
              icon: icon,
              action: action,
            ),
            (value != null
                ? Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text(value, style: TextStyle(fontSize: 12.0)),
                  )
                : Container()),
          ],
        ),
      ),
    );
  }
}
