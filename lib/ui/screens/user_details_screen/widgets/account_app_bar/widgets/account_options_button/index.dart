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
    final titles = <AccountOptions, String>{
      AccountOptions.EditAccount:
          PostsLocalizations.of(context).translate(Messages.editAccountOption),
      AccountOptions.ViewMnemonic:
          PostsLocalizations.of(context).translate(Messages.viewMnemonicOption),
      AccountOptions.Logout:
          PostsLocalizations.of(context).translate(Messages.logoutOption),
    };

    return PopupMenuButton<AccountOptions>(
      offset: Offset(0, 100.0),
      onSelected: (option) => _onSelected(context, option),
      child: Container(
        margin: EdgeInsets.only(
          top: 7,
          left: 7,
          bottom: 7,
          right: 10,
        ),
        child: Material(
          shape: CircleBorder(),
          color: Colors.grey[700].withOpacity(0.5), // button color
          child: SizedBox(
            width: 35,
            height: 35,
            child: Icon(
              MooncakeIcons.settings,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ),
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
      var userAddress =
          (BlocProvider.of<AccountBloc>(context).state as LoggedIn)
              .user
              .address;
      BlocProvider.of<NavigatorBloc>(context)
          .add(NavigateToShowMnemonicAuth(userAddress));
    } else if (option == AccountOptions.Logout) {
      BlocProvider.of<AccountBloc>(context).add(
        LogOut((BlocProvider.of<AccountBloc>(context).state as LoggedIn)
            .user
            .address),
      );
    }
  }
}
