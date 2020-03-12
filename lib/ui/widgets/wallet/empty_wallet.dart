import 'package:flutter/material.dart';
import 'package:mooncake/ui/localization/export.dart';

/// Represents the screen that is shown to the user when he was no coins yet.
class EmptyWallet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            PostsLocalizations.of(context).emptyWalletTitle,
            style: Theme.of(context).textTheme.headline6,
          ),
          Image(
            height: 150,
            image: AssetImage("assets/icons/icon_ghost.png"),
          ),
          Text(
            PostsLocalizations.of(context).emptyWalletBody,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
