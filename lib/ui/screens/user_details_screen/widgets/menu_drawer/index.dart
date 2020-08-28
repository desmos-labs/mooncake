import 'package:flutter/material.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';

class MenuDrawer extends StatelessWidget {
  final User user;
  final List<MooncakeAccount> accounts;

  MenuDrawer({
    @required this.user,
    @required this.accounts,
  });

  List<Widget> _listAccounts(BuildContext context) {
    final List<Widget> results = [];
    accounts.forEach(
      (user) {
        results.add(
          ListTile(
            leading: AccountAvatar(user: user, size: 40),
            title: Text(user.screenName, textAlign: TextAlign.end),
            onTap: () {
              // wingman
              print("ive been called");
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );

    return results;
  }

  _handleCreateNewAccount() {
    print("clicked new account");
  }

  _handleImportMnemonic() {
    print("click import");
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 120,
              child: DrawerHeader(
                child: Container(
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
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                ),
              ),
            ),
            ..._listAccounts(context),
            GestureDetector(
              onTap: _handleImportMnemonic,
              child: Text(
                PostsLocalizations.of(context)
                    .translate(Messages.importMnemonic),
                style: Theme.of(context).textTheme.subtitle1.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: ThemeSpaces.mediumGutter),
            GestureDetector(
              onTap: _handleCreateNewAccount,
              child: Text(
                PostsLocalizations.of(context)
                    .translate(Messages.createAnotherAccount),
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
  }
}
