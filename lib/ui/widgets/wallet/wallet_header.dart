import 'package:alan/alan.dart';
import 'package:flutter/material.dart';
import 'package:mooncake/ui/ui.dart';

/// Represents the header that is shown inside the wallet screen.
class WalletHeader extends StatelessWidget {
  final StdCoin coin;

  const WalletHeader({Key key, @required this.coin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Icon(MooncakeIcons.transactions, size: 40),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              coin.amount,
              style: Theme.of(context).textTheme.headline5,
            ),
            SizedBox(width: 5),
            Text(
              coin.denom,
              style: Theme.of(context).textTheme.caption,
            )
          ],
        ),
        Flexible(child: Container()),
      ],
    );
  }
}
