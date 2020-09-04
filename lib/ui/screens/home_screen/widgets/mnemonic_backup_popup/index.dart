import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/ui/ui.dart';

class MnemonicBackupPopup extends StatelessWidget {
  final test = true;

  void _closePopup(BuildContext context) {
    BlocProvider.of<HomeBloc>(context).add(HideBackupMnemonicPhrasePopup());
  }

  void _turnOffPopupPermission(BuildContext context) {
    BlocProvider.of<HomeBloc>(context)
        .add(TurnOffBackupMnemonicPopupPermission());
  }

  void _NavigateToShowMnemonicAuthAuth(BuildContext context) {
    var userAddress =
        (BlocProvider.of<AccountBloc>(context).state as LoggedIn).user.address;

    BlocProvider.of<NavigatorBloc>(context)
        .add(NavigateToShowMnemonicAuth(userAddress, backupPhrase: true));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MnemonicBloc.create(context),
      child: GenericPopup(
        backgroundColor: Colors.black54,
        width: MediaQuery.of(context).size.width -
            (MediaQuery.of(context).size.width * 0.25),
        content: Container(
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Text(
                  PostsLocalizations.of(context)
                      .translate(Messages.mnemonicBackupBody1),
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              SizedBox(height: 10),
              Text(
                PostsLocalizations.of(context)
                    .translate(Messages.mnemonicBackupBody2),
              ),
              PrimaryButton(
                child: Text(
                  PostsLocalizations.of(context)
                      .translate(Messages.mnemonicBackupButton),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.button.copyWith(
                        color: Colors.white,
                      ),
                ),
                onPressed: () => _NavigateToShowMnemonicAuthAuth(context),
              ),
              SecondaryDarkButton(
                padding: EdgeInsets.all(13),
                child: Text(
                  PostsLocalizations.of(context)
                      .translate(Messages.mnemonicRemindMeLaterButton),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.button.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                onPressed: () => _closePopup(context),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: GestureDetector(
                  onTap: () => _turnOffPopupPermission(context),
                  child: Text(
                    PostsLocalizations.of(context)
                        .translate(Messages.mnemonicDoNotShowAgainButton),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.button.copyWith(
                          fontSize: 12,
                          color: Color(0xFFB8B8B8),
                        ),
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
