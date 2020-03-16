import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mooncake/dependency_injection/injector.dart';
import 'package:mooncake/ui/ui.dart';

/// Represents the body of the biometric authentication set screen.
class SetBiometricBody extends StatelessWidget {
  final LocalAuthentication localAuth = Injector.get();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            PostsLocalizations.of(context).biometricsBody.replaceAll("\n", ""),
            style: Theme.of(context)
                .textTheme
                .bodyText2
                .copyWith(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 25),
          Row(
            children: <Widget>[
              Expanded(
                child: PrimaryLightRoundedButton(
                  child: Text(
                    PostsLocalizations.of(context).biometricsEnableButton,
                  ),
                  onPressed: () => _enableButtonClicked(context),
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: SecondaryLightRoundedButton(
                  child: Text(
                    PostsLocalizations.of(context).biometricsUsePasswordButton,
                  ),
                  onPressed: () => _cancelButtonClicked(context),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void _enableButtonClicked(BuildContext context) {
    final reason = PostsLocalizations.of(context).biometricsReason;
    localAuth.authenticateWithBiometrics(localizedReason: reason).then((value) {
      if (value) {
        BlocProvider.of<BiometricsBloc>(context)
            .add(AuthenticateWithBiometrics());
      }
    }).catchError((error) => print(error));
  }

  void _cancelButtonClicked(BuildContext context) {
    BlocProvider.of<NavigatorBloc>(context).add(NavigateToSetPassword());
  }
}
