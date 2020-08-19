import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/ui/ui.dart';
import 'widgets/export.dart';

/// Screen that is shown to the user when he needs to log into the application.
/// From this screen, he can perform two actions in order to log in:
/// 1. Create a new account with a single click.
/// 2. Recover an existing account using a mnemonic phrase.
class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: ThemeDecorations.pattern(context),
        child: SafeArea(
          child: BlocBuilder<AccountBloc, AccountState>(
            builder: (BuildContext contest, AccountState state) {
              return Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 32, horizontal: 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image(
                              image: AssetImage('assets/images/logo.png'),
                              width: 75,
                            ),
                          ],
                        ),
                        Text(
                          PostsLocalizations.of(context)
                              .translate(Messages.appName),
                          style: Theme.of(context).textTheme.headline6.copyWith(
                                color: Colors.white,
                                fontFamily: 'Montserrat',
                              ),
                        ),
                        if (!(state is AccountCreated ||
                            state is CreatingAccount))
                          LoginMainContent(),
                      ],
                    ),
                  ),
                  if (state is CreatingAccount)
                    LoginPopup(content: CreatingAccountPopupContent()),
                  if (state is AccountCreated)
                    LoginPopup(content: AccountCreatedPopupContent()),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
