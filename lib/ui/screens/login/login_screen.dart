import 'package:mooncake/ui/ui.dart';
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
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  PostsLocalizations.of(context).appTitle,
                  style: Theme.of(context).textTheme.display1.apply(
                    color: PostsTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: <Widget>[
              RaisedButton(
                child: Text(PostsLocalizations.of(context).recoverFromMnemonic),
                onPressed: () => _onRecoverAccount(context),
              ),
              RaisedButton(
                child: Text(PostsLocalizations.of(context).generateNewAccount),
                onPressed: () => _onCreateAccountClicked(context),
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
