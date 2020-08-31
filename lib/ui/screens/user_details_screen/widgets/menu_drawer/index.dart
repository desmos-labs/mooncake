import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
          Container(
            child: Material(
              child: InkWell(
                  onTap: () {
                    // wingman
                    print("ive been called");
                    // Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Row(
                      children: [
                        AccountAvatar(user: user, size: 40),
                        SizedBox(width: 20),
                        Text(user.screenName, textAlign: TextAlign.end),
                      ],
                    ),
                  )),
              color: Colors.transparent,
            ),
          ),
        );
      },
    );

    return results;
  }

  void _handleCreateNewAccount(BuildContext context) {
    print("clicked new account");
    BlocProvider.of<AccountBloc>(context).add(GenerateAccountWhileLoggedIn());
  }

  _handleImportMnemonic() {
    print("click import");
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, state) {
        // wingman
        print("---here----");
        print(state);
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
              ],
            ),
          ),
        );
      },
    );
  }
}
