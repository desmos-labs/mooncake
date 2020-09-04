import 'package:flutter/material.dart';
import 'package:mooncake/ui/localization/export.dart';

/// Represents the screen that is shown to the user when he was no coins yet.
class EmptyWallet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Text(
            PostsLocalizations.of(context).translate(Messages.emptyWalletTitle),
            style: Theme.of(context).textTheme.headline6,
          ),
          Image.asset('assets/images/frowned.png', height: 150),
          Text(
            PostsLocalizations.of(context)
                .translate(Messages.emptyWalletBody)
                .replaceAll('\n', ' '),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
