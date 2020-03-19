import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';

/// Represents the screen that is shown to the user when he wants to
/// visualize the details of its wallet.
class WalletScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (BuildContext context, AccountState accountState) {
        final state = accountState as LoggedIn;
        final coin = state.user.cosmosAccount.coins.firstWhere(
          (c) => c.denom == Constants.FEE_TOKEN,
          orElse: () => null,
        );

        final headerTextColor = Theme.of(context).brightness == Brightness.light
            ? Theme.of(context).primaryColorLight
            : Theme.of(context).accentColor;
        return Scaffold(
          appBar: AppBar(
            iconTheme: Theme.of(context).appBarTheme.iconTheme.copyWith(
                  color: headerTextColor,
                ),
          ),
          backgroundColor: Theme.of(context).brightness == Brightness.light
              ? Theme.of(context).accentColor
              : Theme.of(context).cardColor,
          body: coin == null
              ? EmptyWallet(textColor: headerTextColor)
              : Column(
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: WalletHeader(
                        coin: coin,
                        textColor: headerTextColor,
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: WalletActionsList(),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
