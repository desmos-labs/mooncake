import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/ui/ui.dart';
import "blocs/export.dart";

/// Screen that allows you to import a previously created mnemonic backup.
class RestoreMnemonicBackupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          PostsLocalizations.of(context).restoreMnemonicBackupScreenTitle,
        ),
        centerTitle: true,
      ),
      body: BlocProvider<RestoreBackupBloc>(
        create: (context) => RestoreBackupBloc.create(context),
        child: BlocBuilder<RestoreBackupBloc, RestoreBackupState>(
          builder: (context, state) {
            return Container(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    PostsLocalizations.of(context)
                        .restoreMnemonicInstructions
                        .replaceAll("\n", " "),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: TextField(
                      expands: true,
                      minLines: null,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: PostsLocalizations.of(context)
                            .restoreBackupFieldHint,
                        errorText: state.isBackupValid
                            ? null
                            : PostsLocalizations.of(context).errorBackupInvalid,
                      ),
                      onChanged: (value) => _onBackupChanged(context, value),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      hintText: PostsLocalizations.of(context)
                          .restorePasswordFieldHint,
                      errorText: state.isPasswordValid
                          ? null
                          : PostsLocalizations.of(context)
                              .errorBackupPasswordWrong,
                    ),
                    onChanged: (value) => _onPasswordChanged(context, value),
                  ),
                  const SizedBox(height: 16),
                  if (!state.restoring)
                    PrimaryButton(
                      onPressed: () => _restoreBackup(context),
                      child: Text(
                        PostsLocalizations.of(context).restoreButtonText,
                      ),
                      enabled: state.isBackupValid,
                    ),
                  if (state.restoring) LoadingIndicator(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _onBackupChanged(BuildContext context, String backup) {
    BlocProvider.of<RestoreBackupBloc>(context).add(BackupTextChanged(backup));
  }

  void _onPasswordChanged(BuildContext context, String password) {
    BlocProvider.of<RestoreBackupBloc>(context)
        .add(EncryptPasswordChanged(password));
  }

  void _restoreBackup(BuildContext context) {
    BlocProvider.of<RestoreBackupBloc>(context).add(RestoreBackup());
  }
}
