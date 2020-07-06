import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/ui/ui.dart';

/// Represents the app bar that is shown to the user when he visualizes
/// the account screen.
AppBar accountAppBar(BuildContext context) {
  final actions = [
    PostsLocalizations.of(context).editAccountOption,
    PostsLocalizations.of(context).viewMnemonicOption,
    PostsLocalizations.of(context).logoutOption,
  ];

  void _onSelected(BuildContext context, String option) {
    if (option == actions[0]) {
      // Edit account
      BlocProvider.of<NavigatorBloc>(context).add(NavigateToEditAccount());
    } else if (option == actions[1]) {
      // See mnemonic
      BlocProvider.of<NavigatorBloc>(context).add(NavigateToShowMnemonicAuth());
    } else if (option == actions[2]) {
      // Logout
      BlocProvider.of<AccountBloc>(context).add(LogOut());
      BlocProvider.of<NavigatorBloc>(context).add(NavigateToHome());
    }
  }

  return AppBar(
    centerTitle: true,
    title: Text(
      PostsLocalizations.of(context).accountScreenTitle,
    ),
    backgroundColor: Colors.transparent,
    actions: [
      IconButton(
        icon: Icon(MooncakeIcons.wallet),
        tooltip: PostsLocalizations.of(context).walletButtonTooltip,
        onPressed: () {
          BlocProvider.of<NavigatorBloc>(context).add(NavigateToWallet());
        },
      ),
      PopupMenuButton<String>(
        onSelected: (option) => _onSelected(context, option),
        itemBuilder: (context) {
          return actions.map((entry) {
            return PopupMenuItem<String>(
              value: entry,
              child: Text(entry),
            );
          }).toList();
        },
      )
    ],
  );
}
