import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/ui/ui.dart';

/// Screen to confirm mnemonic backup phrase
class BackupMnemonicConfirmationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecoverAccountBloc, RecoverAccountState>(
      builder: (BuildContext context, RecoverAccountState state) {
        final bottomPadding = 50.0;
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(PostsLocalizations.of(context)
                .translate(Messages.mnemonicConfirmPhrase)),
          ),
          body: SafeArea(
            child: Stack(
              children: <Widget>[
                RecoverAccountMainContent(
                  bottomPadding: bottomPadding,
                  backupPhrase: true,
                ),

                // // Words list
                Positioned(
                  bottom: 0,
                  child: RecoverAccountWordsList(height: bottomPadding),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
