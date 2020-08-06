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
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(bottom: 15),
        child: Container(
          child: Column(
            children: [
              PrimaryButton(
                child: Text(PostsLocalizations.of(context)
                    .translate(Messages.mnemonicBackupWrittenConfirm)),
                onPressed: () => onConfirmationClick(context),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  PostsLocalizations.of(context)
                      .translate(Messages.mnemonicWrittenConfirmation),
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
