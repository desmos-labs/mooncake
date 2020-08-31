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

  void _handleImportMnemonic() {
    print("click import");
  }

  void _handleSwitchAccount(BuildContext context, MooncakeAccount user) {
    BlocProvider.of<AccountBloc>(context).add(SwitchAccount(user));
    Navigator.of(context).pop();
  }

  void _handleLogOutAll(BuildContext context) {
    BlocProvider.of<AccountBloc>(context).add(LogOutAll());
  }

  List<Widget> _listAccounts(BuildContext context) {
    final List<Widget> results = [];
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
        return Drawer(
          child: Container(
            color: Colors.white,
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                SafeArea(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
                    child: Row(
                      children: [
                        AccountAvatar(user: user, size: 50),
                        SizedBox(width: 10),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                '${PostsLocalizations.of(context).translate(Messages.hello)},',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    .copyWith(
                                      fontSize: 16,
                                    )),
                            Text(user.screenName,
                                style: Theme.of(context).textTheme.headline6),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                ..._listAccounts(context),
                SizedBox(height: ThemeSpaces.mediumGutter),
                // wingman
                // to do later
                // GestureDetector(
                //   onTap: _handleImportMnemonic,
                //   child: Text(
                //     PostsLocalizations.of(context)
                //         .translate(Messages.importMnemonic),
                //     style: Theme.of(context).textTheme.subtitle1.copyWith(
                //           color: Theme.of(context).colorScheme.primary,
                //         ),
                //     textAlign: TextAlign.center,
                //   ),
                // ),
                SizedBox(height: ThemeSpaces.mediumGutter),
                GestureDetector(
                  onTap: () => _handleCreateNewAccount(context),
                  child: Text(
                    PostsLocalizations.of(context)
                        .translate(Messages.createAnotherAccount),
                    style: Theme.of(context).textTheme.subtitle1.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
                // wingman
                // to do later
                GestureDetector(
                  onTap: () => _handleLogOutAll(context),
                  child: Text(
                    PostsLocalizations.of(context)
                        .translate(Messages.logoutAll),
                    style: Theme.of(context).textTheme.subtitle1.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
