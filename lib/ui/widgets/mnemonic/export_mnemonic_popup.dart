import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:mooncake/ui/widgets/security_set_password/password_strength_indicator.dart';

/// Represents the popup that allows the user to export his mnemonic to an
/// encrypted field.
class ExportMnemonicPopup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MnemonicBloc, MnemonicState>(
      builder: (context, mnemonicState) {
        final state = mnemonicState as ExportingMnemonic;
        return GenericPopup(
          backgroundColor: Theme.of(context).primaryColorDark.withOpacity(0.25),
          content: Column(
            children: [
              Text(
                PostsLocalizations.of(context).exportMnemonicDialogTitle,
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(height: 16),
              Text(
                PostsLocalizations.of(context)
                    .exportMnemonicDialogText
                    .replaceAll("\n", " "),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              TextField(
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  hintText: PostsLocalizations.of(context)
                      .exportMnemonicDialogPasswordHint,
                ),
                onChanged: (value) => _changeEncryptPassword(context, value),
              ),
              PasswordStrengthIndicator(security: state.passwordSecurity),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SecondaryLightRoundedButton(
                    onPressed: () => _closePopup(context),
                    child: Text(
                      PostsLocalizations.of(context)
                          .exportMnemonicDialogCancelButton,
                    ),
                  ),
                  const SizedBox(width: 16),
                  PrimaryLightRoundedButton(
                    onPressed: state.enableExport
                        ? () => _exportMnemonic(context)
                        : null,
                    child: Text(
                      PostsLocalizations.of(context)
                          .exportMnemonicDialogExportButton,
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  void _changeEncryptPassword(BuildContext context, String password) {
    BlocProvider.of<MnemonicBloc>(context).add(ChangeEncryptPassword(password));
  }

  void _exportMnemonic(BuildContext context) {
    BlocProvider.of<MnemonicBloc>(context).add(ExportMnemonic());
  }

  void _closePopup(BuildContext context) {
    BlocProvider.of<MnemonicBloc>(context).add(CloseExportPopup());
  }
}
