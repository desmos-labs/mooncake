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
        final coin = state.user.accountData.coins.firstWhere(
          (c) => c.denom == Constants.FEE_TOKEN,
          orElse: () => null,
        );

        return Scaffold(
          appBar: AppBar(
            backgroundColor: ThemeColors.accentColor,
            elevation: 0,
            iconTheme: Theme.of(context).accentIconTheme,
          ),
          body: coin == null
              ? EmptyWallet()
              : Column(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: WalletHeader(coin: coin),
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
