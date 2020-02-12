import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mooncake/ui/ui.dart';

/// Screen that is shown to the user when he needs to log into the application.
/// From this screen, he can perform two actions in order to log in:
/// 1. Recover an existing account using a mnemonic phrase.
/// 2. Crete a new random mnemonic.
class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 32, horizontal: 64),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 40),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SvgPicture.asset(
                    'assets/images/logo.svg',
                    width: 100,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 32),
                  Text(
                    PostsLocalizations.of(context).loginTitle,
                    style: Theme.of(context).textTheme.headline5.copyWith(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          PostsLocalizations.of(context).loginText,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                                color: Colors.grey[300],
                                fontSize: 16,
                              ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            RaisedButton(
              color: Theme.of(context).primaryColorLight,
              textColor: Theme.of(context).primaryColor,
              child: Text(PostsLocalizations.of(context).recoverFromMnemonic),
              onPressed: () => _onRecoverAccount(context),
            ),
            FlatButton(
              textColor: Theme.of(context).primaryColorLight,
              child: Text(PostsLocalizations.of(context).generateNewAccount),
              onPressed: () => _onCreateAccountClicked(context),
            )
          ],
        ),
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
