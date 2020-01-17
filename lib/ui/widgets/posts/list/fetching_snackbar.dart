import 'package:mooncake/ui/ui.dart';
import 'package:flutter/material.dart';

/// Represents the snackbar that is shown to the user during the
/// fetching of new posts from the chain.
class FetchingSnackbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.blue,
      child: Row(
        children: <Widget>[
          Icon(FontAwesomeIcons.cloudDownloadAlt, size: 16),
        const SizedBox(width: 16),
          Text(PostsLocalizations.of(context).fetchingPosts),
        ],
      ),
    );
  }
}
