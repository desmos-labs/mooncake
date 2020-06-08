import 'package:flutter/material.dart';
import 'package:mooncake/ui/localization/export.dart';
import 'package:mooncake/ui/theme/colors.dart';

/// Used to show the user the fact that activities are being synced.
class PostsListSyncingIndicator extends StatelessWidget {
  final bool visible;

  const PostsListSyncingIndicator({
    Key key,
    @required this.visible,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(height: 3, child: LinearProgressIndicator()),
          const SizedBox(height: 4),
          Text(
            PostsLocalizations.of(context).syncingActivities,
            style: Theme.of(context).textTheme.caption.copyWith(
                  color: Theme.of(context).accentColor,
                ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
