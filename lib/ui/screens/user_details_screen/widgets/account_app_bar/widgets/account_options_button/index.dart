import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/ui/ui.dart';

/// Represents the list of options that the user can select from the
/// account popup.
enum AccountOptions {
  EditAccount,
  ViewMnemonic,
  Logout,
}

/// Button used to display the options of the current user account.
/// This buttons allows to show a popup that contains the options to
/// either edit the account, logout of show his mnemonic.
class AccountOptionsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<AccountOptions, String> titles = {
      AccountOptions.EditAccount:
          PostsLocalizations.of(context).translate(Messages.editAccountOption),
      AccountOptions.ViewMnemonic:
          PostsLocalizations.of(context).translate(Messages.viewMnemonicOption),
      AccountOptions.Logout:
          PostsLocalizations.of(context).translate(Messages.logoutOption),
    };

    return PopupMenuButton<AccountOptions>(
      onSelected: (option) => _onSelected(context, option),
      icon: Icon(MooncakeIcons.more),
      itemBuilder: (context) {
        return AccountOptions.values.map((value) {
          return PopupMenuItem<AccountOptions>(
            value: value,
            child: Text(titles[value]),
          );
        }).toList();
      },
    );
  }

  void _onSelected(BuildContext context, AccountOptions option) {
    if (option == AccountOptions.EditAccount) {
      BlocProvider.of<NavigatorBloc>(context).add(NavigateToEditAccount());
    } else if (option == AccountOptions.ViewMnemonic) {
      String userAddress =
          (BlocProvider.of<AccountBloc>(context).state as LoggedIn)
              .user
              .address;
      BlocProvider.of<NavigatorBloc>(context)
          .add(NavigateToShowMnemonicAuth(userAddress));
    } else if (option == AccountOptions.Logout) {
      BlocProvider.of<AccountBloc>(context).add(LogOut(
          (BlocProvider.of<AccountBloc>(context).state as LoggedIn)
              .user
              .address));
      BlocProvider.of<NavigatorBloc>(context).add(NavigateToHome());
    }
  }
}
