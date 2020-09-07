import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';
import 'widgets/export.dart';

/// Represents the screen that is shown to the user when he wants to
/// visualize the details of its wallet.
class WalletScreen extends StatefulWidget {
  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  Completer<void> _refreshCompleter;

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      cubit: BlocProvider.of<AccountBloc>(context)..add(RefreshAccount()),
      builder: (BuildContext context, AccountState accountState) {
        final state = accountState as LoggedIn;
        final coin = state.user.cosmosAccount.coins.firstWhere(
          (c) => c.denom == Constants.FEE_TOKEN,
          orElse: () => null,
        );

        if (!state.refreshing) {
          _refreshCompleter?.complete();
          _refreshCompleter = Completer();
        }

        return Scaffold(
          appBar: AppBar(),
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () {
                BlocProvider.of<AccountBloc>(context).add(RefreshAccount());
                return _refreshCompleter.future;
              },
              child: coin == null
                  ? EmptyWallet()
                  : SingleChildScrollView(
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          children: <Widget>[
                            Flexible(
                              child: WalletHeader(coin: coin),
                            ),
                            Expanded(
                              flex: 4,
                              child: WalletActionsList(),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}
