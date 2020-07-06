import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/ui/ui.dart';

class BackupMnemonicButton extends StatelessWidget {
  void onConfirmationClick(BuildContext context) {
    BlocProvider.of<NavigatorBloc>(context)
        .add(NavigateToConfirmMnemonicBackupPhrase());
  }

  @override
  Widget build(BuildContext context) {
    // wingman come back and fix styling later
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(bottom: 15),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              PrimaryButton(
                child: Text(PostsLocalizations.of(context)
                    .mnemonicBackupWrittenConfirm),
                onPressed: () => onConfirmationClick(context),
              ),
              Text(PostsLocalizations.of(context).mnemonicWrittenConfirmation),
            ],
          ),
        ),
      ),
    );
  }
}
