import 'package:flutter/material.dart';
import 'package:mooncake/ui/localization/export.dart';

/// Used to show the user the fact that activities are being synced.
class PostsListSyncingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(height: 3, child: LinearProgressIndicator()),
        const SizedBox(height: 4),
        Text(
          PostsLocalizations.of(context).translate(Messages.syncingActivities),
          style: Theme.of(context).textTheme.caption.copyWith(
                color: Theme.of(context).accentColor,
              ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
