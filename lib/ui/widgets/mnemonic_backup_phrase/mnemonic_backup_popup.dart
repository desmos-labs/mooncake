import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/ui/ui.dart';

class MnemonicBackupPopup extends StatelessWidget {
  final test = true;

  void _closePopup(BuildContext context) {
    BlocProvider.of<MnemonicBloc>(context).add(HideBackupMnemonicPhrasePopup());
  }

  void _turnOffPopupPermission(BuildContext context) {
    BlocProvider.of<MnemonicBloc>(context)
        .add(TurnOffBackupMnemonicPopupPermission());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MnemonicBloc.create(context),
      child: BlocBuilder<MnemonicBloc, MnemonicState>(
        builder: (context, state) {
          BlocProvider.of<MnemonicBloc>(context)
              .add(ValidateBackupMnemonicPopupState());

          if (state.showBackupPhrasePopup) {
            return GenericPopup(
              backgroundColor: Colors.black54,
              width: MediaQuery.of(context).size.width -
                  (MediaQuery.of(context).size.width * 0.25),
              content: Container(
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        PostsLocalizations.of(context).mnemonicBackupBody1,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      PostsLocalizations.of(context).mnemonicBackupBody2,
                    ),
                    PrimaryButton(
                      child: Text(
                        PostsLocalizations.of(context).mnemonicBackupButton,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.button.copyWith(
                              color: Colors.white,
                            ),
                      ),
                      onPressed: () => null,
                    ),
                    PrimaryButton(
                      child: Text(
                        PostsLocalizations.of(context)
                            .mnemonicRemindMeLaterButton,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.button.copyWith(
                              color: Colors.white,
                            ),
                      ),
                      onPressed: () => _closePopup(context),
                    ),
                    SecondaryLightInvertRoundedButton(
                      width: double.infinity,
                      child: Text(
                        PostsLocalizations.of(context)
                            .mnemonicDoNotShowAgainButton,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.button.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                      onPressed: () => _turnOffPopupPermission(context),
                    ),
                  ],
                ),
              ),
            );
          }
          ;
          return Container(width: 0.0, height: 0.0);
        },
      ),
    );
  }
}
