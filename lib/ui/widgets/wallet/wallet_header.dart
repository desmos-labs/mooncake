import 'package:alan/alan.dart';
import 'package:flutter/material.dart';
import 'package:mooncake/ui/ui.dart';

/// Represents the header that is shown inside the wallet screen.
class WalletHeader extends StatelessWidget {
  final StdCoin coin;
  final Color textColor;

  const WalletHeader({
    Key key,
    @required this.coin,
    @required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: kTextTabBarHeight),
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Icon(MooncakeIcons.taskList, size: 40, color: textColor),
          Flexible(child: Container()),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                coin.amount,
                style: Theme.of(context).textTheme.headline5.copyWith(
                      color: textColor,
                    ),
              ),
              SizedBox(width: 5),
              Text(
                coin.denom,
                style: Theme.of(context).textTheme.caption.copyWith(
                      color: textColor,
                    ),
              )
            ],
          )
        ],
      ),
    );
  }
}
