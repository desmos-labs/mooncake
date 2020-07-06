import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mooncake/dependency_injection/dependency_injection.dart';
import 'package:mooncake/ui/blocs/mnemonic/mnemonic_bloc.dart';
import 'package:mooncake/ui/ui.dart';

/// Represents the screen that allows the user to view his mnemonic phrase
/// after logging in using the same biometric credential he used while
/// setting up the account.
class LoginWithBiometricsScreen extends StatelessWidget {
  final LocalAuthentication localAuth = Injector.get();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(PostsLocalizations.of(context).viewMnemonic),
      ),
      body: BlocBuilder<MnemonicBloc, MnemonicState>(
        builder: (context, state) {
          return Stack(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                child: ListView(
                  children: [
                    Text(
                      PostsLocalizations.of(context)
                          .securityLoginText
                          .replaceAll("\n", ""),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      PostsLocalizations.of(context)
                          .securityLoginWarning
                          .replaceAll("\n", ""),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      PostsLocalizations.of(context)
                          .securityLoginBiometrics
                          .replaceAll("\n", ""),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    if (!state.showMnemonic)
                      PrimaryButton(
                        onPressed: () => _enableButtonClicked(context),
                        child:
                            Text(PostsLocalizations.of(context).viewMnemonic),
                      ),
                    if (state.showMnemonic)
                      MnemonicVisualizer(
                        mnemonic: state.mnemonic,
                      ),
                  ],
                ),
              ),

              // Exporting popup
              if (state is ExportingMnemonic) ExportMnemonicPopup(),
            ],
          );
        },
      ),
    );
  }

  void _enableButtonClicked(BuildContext context) {
    final reason = PostsLocalizations.of(context).biometricsReason;
    localAuth.authenticateWithBiometrics(localizedReason: reason).then((value) {
      if (value) {
        BlocProvider.of<MnemonicBloc>(context).add(ShowMnemonic());
      }
    }).catchError((error) => print(error));
  }
}
