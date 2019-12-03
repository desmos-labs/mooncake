import 'package:desmosdemo/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Screen that is shown to the user when he needs to log into the application.
/// From this screen, he can perform two actions in order to log in:
/// 1. Recover an existing account using a mnemonic phrase.
/// 2. Crete a new random mnemonic.
class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      color: PostsTheme.primaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  PostsLocalizations.of(context).appTitle,
                  style: PostsTheme.theme.textTheme.display1,
                ),
              ],
            ),
          ),
          Column(
            children: <Widget>[
              FlatButton(
                color: PostsTheme.accentColor,
                child: Text(PostsLocalizations.of(context).recoverFromMnemonic),
                onPressed: () => _onRecoverAccount(context),
              ),
              FlatButton(
                color: PostsTheme.accentColor,
                child: Text(PostsLocalizations.of(context).generateNewAccount),
                // TODO: Handle this
                onPressed: true ? null : () => _onCreateAccountClicked(context),
              )
            ],
          )
        ],
      ),
    );
  }

  void _onRecoverAccount(BuildContext context) {
    BlocProvider.of<NavigatorBloc>(context).add(NavigateToRecoverAccount());
  }

  void _onCreateAccountClicked(BuildContext context) {
    BlocProvider.of<NavigatorBloc>(context).add(NavigateToCreateAccount());
  }
}
