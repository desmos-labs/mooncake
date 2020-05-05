import 'package:flutter/material.dart';
import 'package:mooncake/ui/ui.dart';

import 'common.dart';

/// Allows to edit the text of a poll option, edit the associated image (or
/// add a new one) or delete the option entirely.
class PollOptionEditor extends StatelessWidget {
  final int index;

  const PollOptionEditor({Key key, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hintText = "${PostsLocalizations.of(context).pollOptionHint} $index";
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: getInputDecoration(context),
        padding: EdgeInsets.all(4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: hintText,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(MooncakeIcons.picture),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(MooncakeIcons.delete),
                  onPressed: () {},
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
