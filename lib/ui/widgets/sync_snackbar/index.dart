import 'package:flutter/material.dart';
import 'package:mooncake/ui/ui.dart';

/// Represents the snackbar that is shown during the synchronization
/// of new posts into the chain
class SyncSnackBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      color: Theme.of(context).colorScheme.primary,
      child: Row(
        children: <Widget>[
          Icon(
            FontAwesomeIcons.cloudUploadAlt,
            size: 16,
            color: Colors.white,
          ),
          const SizedBox(width: 16),
          Text(
            PostsLocalizations.of(context)
                .translate(Messages.syncingActivities),
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
