import 'package:dwitter/ui/ui.dart';
import 'package:flutter/material.dart';

/// Represents the snackbar that is shown during the synchronization
/// of new posts into the chain
class SyncSnackBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.orange,
      child: Row(
        children: <Widget>[
          Icon(FontAwesomeIcons.cloudUploadAlt, size: 16),
          SizedBox(width: 16),
          Text(PostsLocalizations.of(context).syncingActivities),
        ],
      ),
    );
  }
}
