import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/ui/ui.dart';
import 'widgets/export.dart';

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
                Text('Decentralized', style: titleTextTheme),
                Text('Social Network', style: titleTextTheme),
              ],
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: PrimaryLightButton(
              child: Text(
                PostsLocalizations.of(context)
                    .translate(Messages.createAccountButtonText),
              ),
              onPressed: () => _onCreateAccountClicked(context),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 4),
            child: SizedBox(
              width: double.infinity,
              child: SecondaryLightButton(
                child: Text(
                  PostsLocalizations.of(context)
                      .translate(Messages.alreadyHaveMnemonicButtonText),
                  textAlign: TextAlign.center,
                ),
                onPressed: () => _onRecoverAccount(context),
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: SecondaryLightButton(
              child: Text(
                PostsLocalizations.of(context)
                    .translate(Messages.useMnemonicBackup),
                textAlign: TextAlign.center,
              ),
              onPressed: () => _onRecoverBackup(context),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 15, bottom: 10),
            child: LoginTermsAndConditions(align: TextAlign.center),
          ),
        ],
      ),
    );
  }

  void _onRecoverBackup(BuildContext context) {
    BlocProvider.of<NavigatorBloc>(context).add(NavigateToRestoreBackup());
  }

  void _onRecoverAccount(BuildContext context) {
    BlocProvider.of<NavigatorBloc>(context).add(NavigateToRecoverAccount());
  }

  void _onCreateAccountClicked(BuildContext context) {
    BlocProvider.of<AccountBloc>(context).add(GenerateAccount());
  }
}
