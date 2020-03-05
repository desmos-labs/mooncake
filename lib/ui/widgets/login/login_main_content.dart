import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/ui/ui.dart';

/// Represents the main login content containing the title and the
/// login and recover account buttons.
class LoginMainContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 32),
                Text(
                  "Decentralized",
                  style: TextThemes.loginTitleTheme(context),
                ),
                Text(
                  "Social Network",
                  style: TextThemes.loginTitleTheme(context),
                ),
              ],
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: PrimaryLightRoundedButton(
                  child: Text(
                      PostsLocalizations.of(context).createAccountButtonText),
                  onPressed: () => _onCreateAccountClicked(context),
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: SecondaryLightRoundedButton(
                  child: Text(PostsLocalizations.of(context)
                      .alreadyHaveMnemonicButtonText),
                  onPressed: () => _onRecoverAccount(context),
                ),
              ),
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
    BlocProvider.of<AccountBloc>(context).add(GenerateAccount());
  }
}
