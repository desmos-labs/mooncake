import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mooncake/ui/localization/export.dart';

/// Contains all the actions that the user has done that cost some tokens.
class WalletActionsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            PostsLocalizations.of(context).translate(Messages.walletTitle),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline6,
          ),
          Image.asset('assets/images/tongue.png', width: 150),
          Text(
            PostsLocalizations.of(context)
                .translate(Messages.walletBodyText)
                .replaceAll('\n', ' '),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
