import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mooncake/dependency_injection/dependency_injection.dart';
import 'package:mooncake/ui/ui.dart';

/// Represents the screen that allows the user to view his mnemonic phrase
/// after logging in using the same biometric credential he used while
/// setting up the account.
class LoginWithBiometricsScreen extends StatelessWidget {
  final LocalAuthentication localAuth = Injector.get();
  final bool backupPhrase;

  LoginWithBiometricsScreen({
    this.backupPhrase = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
            PostsLocalizations.of(context).translate(Messages.viewMnemonic)),
      ),
      body: BlocProvider<MnemonicBloc>(
        create: (context) => MnemonicBloc.create(context),
        child: BlocBuilder<MnemonicBloc, MnemonicState>(
          builder: (context, state) {
            return Stack(
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  child: state.showMnemonic
                      ? MnemonicVisualizer(
                          mnemonic: state.mnemonic,
                          allowExport: backupPhrase ? false : true,
                          backupPhrase: backupPhrase,
                        )
                      : ListView(
                          children: [
                            Text(
                              PostsLocalizations.of(context)
                                  .translate(Messages.securityLoginText)
                                  .replaceAll('\n', ' '),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              PostsLocalizations.of(context)
                                  .translate(Messages.securityLoginWarning)
                                  .replaceAll('\n', ' '),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              PostsLocalizations.of(context)
                                  .translate(Messages.securityLoginBiometrics)
                                  .replaceAll('\n', ' '),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            CheckBoxButton(
                              value: state.hasCheckedBox,
                              child: Expanded(
                                child: Text(PostsLocalizations.of(context)
                                    .translate(
                                        Messages.understoodMnemonicDisclaimer)),
                              ),
                              onChanged: (_) => _checkBoxChanged(context),
                            ),
                            const SizedBox(height: 16),
                            if (!state.showMnemonic)
                              PrimaryButton(
                                onPressed: () => _enableButtonClicked(context),
                                enabled: state.hasCheckedBox,
                                child: Text(PostsLocalizations.of(context)
                                    .translate(Messages.viewMnemonic)),
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
      ),
    );
  }

  void _checkBoxChanged(BuildContext context) {
    BlocProvider.of<MnemonicBloc>(context).add(ToggleCheckBox());
  }

  void _enableButtonClicked(BuildContext context) {
    final reason =
        PostsLocalizations.of(context).translate(Messages.biometricsReason);
    localAuth.authenticateWithBiometrics(localizedReason: reason).then((value) {
      if (value) {
        final user =
            (BlocProvider.of<AccountBloc>(context).state as LoggedIn).user;
        BlocProvider.of<MnemonicBloc>(context).add(ShowMnemonic(user.address));
      }
    }).catchError((error) => print(error));
  }
}
