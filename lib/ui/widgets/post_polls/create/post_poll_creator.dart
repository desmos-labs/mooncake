import 'package:flutter/material.dart';
import 'package:mooncake/ui/localization/export.dart';

import 'poll_title_editor.dart';
import 'poll_option_editor.dart';
import 'poll_end_date_editor.dart';

/// Represents the serie of widgets that allow to create a poll for a post.
class PostPollCreator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        PollTitleEditor(),
        const SizedBox(height: 8),
        ListView.separated(
          shrinkWrap: true,
          itemCount: 2,
          itemBuilder: (context, index) {
            return PollOptionEditor(index: index);
          },
          separatorBuilder: (context, index) {
            return SizedBox(height: 8);
          },
        ),
        const SizedBox(height: 4),
        FlatButton(
          textColor: Theme.of(context).accentColor,
          child: Text(PostsLocalizations.of(context).pollAddOptionButton),
          onPressed: (){},
        ),
        const SizedBox(height: 4),
        PollEndDateEditor(),
      ],
    );
  }
}
