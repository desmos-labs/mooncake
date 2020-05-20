import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/ui/ui.dart';

import 'login_terms_conditions.dart';

/// Represents the main login content containing the title and the
/// login and recover account buttons.
class LoginMainContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final titleTextTheme = Theme.of(context).textTheme.bodyText2.copyWith(
          fontSize: 32,
          color: Colors.white,
        );
    return Expanded(
      child: Column(
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 32),
                Text("Decentralized", style: titleTextTheme),
                Text("Social Network", style: titleTextTheme),
              ],
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: PrimaryLightRoundedButton(
                  child: Text(
                    PostsLocalizations.of(context).createAccountButtonText,
                  ),
                  onPressed: () => _onCreateAccountClicked(context),
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: SecondaryLightRoundedButton(
                  child: Text(
                    PostsLocalizations.of(context)
                        .alreadyHaveMnemonicButtonText,
                  ),
                  onPressed: () => _onRecoverAccount(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LoginTermsAndConditions(),
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
