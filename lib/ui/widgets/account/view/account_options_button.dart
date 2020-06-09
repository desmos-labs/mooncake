import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/ui/ui.dart';

class AccountOptionsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final actions = [
      PostsLocalizations.of(context).editAccountOption,
      PostsLocalizations.of(context).viewMnemonicOption,
      PostsLocalizations.of(context).logoutOption,
    ];

    return PopupMenuButton<String>(
      onSelected: (option) => _onSelected(context, actions, option),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.grey.withOpacity(0.75),
        ),
        padding: EdgeInsets.all(4),
        child: Icon(MooncakeIcons.more, color: Colors.white, size: 18),
      ),
      itemBuilder: (context) {
        return actions.map((entry) {
          return PopupMenuItem<String>(
            value: entry,
            child: Text(entry),
          );
        }).toList();
      },
    );
  }

  void _onSelected(BuildContext context, List<String> actions, String option) {
    if (option == actions[0]) {
      // Edit account
      BlocProvider.of<NavigatorBloc>(context).add(NavigateToEditAccount());
    } else if (option == actions[1]) {
      // See mnemonic
      BlocProvider.of<NavigatorBloc>(context).add(NavigateToShowMnemonic());
    } else if (option == actions[2]) {
      // Logout
      BlocProvider.of<AccountBloc>(context).add(LogOut());
      BlocProvider.of<NavigatorBloc>(context).add(NavigateToHome());
    }
  }
}
