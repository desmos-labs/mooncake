import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mooncake/dependency_injection/injector.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:mooncake/ui/screens/security_set_biometrics_screen/blocs/export.dart';

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
            PostsLocalizations.of(context)
                .translate(Messages.biometricsBody)
                .replaceAll('\n', ' '),
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
                child: PrimaryLightButton(
                  child: Text(
                    PostsLocalizations.of(context)
                        .translate(Messages.biometricsEnableButton),
                  ),
                  onPressed: () => _enableButtonClicked(context),
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: SecondaryLightButton(
                  child: Text(
                    PostsLocalizations.of(context)
                        .translate(Messages.biometricsUsePasswordButton),
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
    final reason = PostsLocalizations.of(context).translate(
      Messages.biometricsReason,
    );
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
