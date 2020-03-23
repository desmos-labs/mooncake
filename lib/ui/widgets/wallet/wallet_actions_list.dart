import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mooncake/ui/localization/export.dart';

/// Contains all the actions that the user has done that cost some tokens.
class WalletActionsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            PostsLocalizations.of(context).walletTitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline6,
          ),
          SizedBox(height: 20),
          Image(
            height: 150,
            image: AssetImage("assets/images/ghost.png"),
          ),
          SizedBox(height: 20),
          Text(
            PostsLocalizations.of(context).walletBodyText.replaceAll("\n", " "),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
