import 'package:flutter/material.dart';
import 'package:mooncake/ui/localization/export.dart';

/// Represents the screen that is shown to the user when he was no coins yet.
class EmptyWallet extends StatelessWidget {
  final Color textColor;

  const EmptyWallet({Key key, this.textColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Text(
            PostsLocalizations.of(context).emptyWalletTitle,
            style: Theme.of(context).textTheme.headline6.copyWith(
                  color: textColor,
                ),
          ),
          Image.asset("assets/images/frowned.png", height: 150),
          Text(
            PostsLocalizations.of(context)
                .emptyWalletBody
                .replaceAll("\n", " "),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyText2.copyWith(
                  color: textColor,
                ),
          ),
        ],
      ),
    );
  }
}
