import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';
import './widgets/export.dart';

class MenuDrawer extends StatelessWidget {
  final User user;
  final List<MooncakeAccount> accounts;

  MenuDrawer({
    @required this.user,
    @required this.accounts,
  });

  void _handleCreateNewAccount(BuildContext context) {
    BlocProvider.of<AccountBloc>(context).add(GenerateAccountWhileLoggedIn());
  }

  void _handleImportMnemonicPhrase(BuildContext context) {
    BlocProvider.of<NavigatorBloc>(context).add(NavigateToRecoverAccount());
  }

  void _handleImportMnemonicBackup(BuildContext context) {
    BlocProvider.of<NavigatorBloc>(context).add(NavigateToRestoreBackup());
  }

  void _handleSwitchAccount(BuildContext context, MooncakeAccount user) {
    BlocProvider.of<AccountBloc>(context).add(SwitchAccount(user));
    Navigator.of(context).pop();
  }

  void _handleLogOutAll(BuildContext context) {
    BlocProvider.of<AccountBloc>(context).add(LogOutAll());
  }

  List<Widget> _listAccounts(BuildContext context) {
    final results = <Widget>[];
    accounts.forEach(
      (user) {
        results.add(
          SingleAccountItem(
            user: user,
            onTap: _handleSwitchAccount,
          ),
        );
      },
    );

    return results;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, state) {
        return Stack(
          children: [
            Drawer(
              child: Container(
                color: Theme.of(context).colorScheme.surface,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: <Widget>[
                          SafeArea(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 30, horizontal: 10),
                              child: Row(
                                children: [
                                  AccountAvatar(user: user, size: 50),
                                  SizedBox(width: 10),
                                  Flexible(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            '${PostsLocalizations.of(context).translate(Messages.hello)},',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6
                                                .copyWith(
                                                  fontSize: 16,
                                                )),
                                        FittedBox(
                                          fit: BoxFit.fitWidth,
                                          child: Text(
                                            user.screenName,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5
                                                .copyWith(
                                                  fontSize: 22,
                                                ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          ..._listAccounts(context),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () => _handleCreateNewAccount(context),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(left: 15),
                        child: Text(
                          PostsLocalizations.of(context)
                              .translate(Messages.createAnotherAccount),
                          style: Theme.of(context).textTheme.subtitle1.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                          // textAlign: TextAlign.center,
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () => _handleImportMnemonicPhrase(context),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(left: 15),
                        child: Text(
                          PostsLocalizations.of(context)
                              .translate(Messages.importMnemonicPhrase),
                          style: Theme.of(context).textTheme.subtitle1.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                          // textAlign: TextAlign.center,
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () => _handleImportMnemonicBackup(context),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(left: 15),
                        child: Text(
                          PostsLocalizations.of(context)
                              .translate(Messages.importMnemonicBackup),
                          style: Theme.of(context).textTheme.subtitle1.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                          // textAlign: TextAlign.center,
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () => _handleLogOutAll(context),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(left: 15),
                        child: Text(
                          PostsLocalizations.of(context)
                              .translate(Messages.logoutAll),
                          style: Theme.of(context).textTheme.subtitle1.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    SizedBox(height: 25),
                  ],
                ),
              ),
            ),
            if (state is CreatingAccountWhileLoggedIn)
              Container(
                child: LoadingIndicator(),
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
          ],
        );
      },
    );
  }
}
