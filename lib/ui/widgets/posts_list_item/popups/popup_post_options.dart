import 'package:flutter/material.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';

import 'popup_report/popup_report.dart';

/// Represents the popup that allows a user to perform some actions related
/// to a post such as reporting it.
class PostOptionsPopup extends StatelessWidget {
  final Post post;
  const PostOptionsPopup({
    Key key,
    @required this.post,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Text(
              PostsLocalizations.of(context).postActionsPopupTitle,
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 8),
            Material(
              child: InkWell(
                onTap: () => _onReportClicked(context),
                child: Container(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        MooncakeIcons.report,
                        color: Theme.of(context).textTheme.bodyText2.color,
                      ),
                      const SizedBox(width: 16),
                      Text(
                        PostsLocalizations.of(context).postActionReport,
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _onReportClicked(BuildContext context) {
    Navigator.pop(context);
    showDialog(
      context: context,
      child: ReportPostPopup(post: post),
    );
  }
}
