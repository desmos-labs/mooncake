import 'package:flutter/material.dart';
import 'package:mooncake/ui/ui.dart';

import 'common.dart';

/// Represents the editor that should be used when changing the
/// question associated to a poll.
class PollTitleEditor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: getInputDecoration(context),
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: PostsLocalizations.of(context).pollQuestionHint,
              ),
            )
          ],
        ),
      ),
    );
  }
}
