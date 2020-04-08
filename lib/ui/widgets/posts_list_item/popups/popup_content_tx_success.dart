import 'package:flutter/material.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:url_launcher/url_launcher.dart';

/// Represents the content of the popup that is shown to him when he
/// long clicks a post item that has been included into a successful
/// transaction.
class PostSuccessPopupContent extends StatelessWidget {
  final String txHash;

  const PostSuccessPopupContent({
    Key key,
    @required this.txHash,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          PostsLocalizations.of(context).syncErrorTitle,
          style: Theme.of(context).textTheme.headline6,
        ),
        const SizedBox(height: 16),
        Text(PostsLocalizations.of(context).syncSuccessBody(txHash)),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FlatButton(
              child: Text(
                PostsLocalizations.of(context).syncSuccessBrowseButton,
              ),
              onPressed: () => _browseTx(),
            )
          ],
        )
      ],
    );
  }

  void _browseTx() async {
    final url = "${Constants.EXPLORER}/transactions/$txHash";
    if (await canLaunch(url)) {
      launch(url);
    }
  }
}
