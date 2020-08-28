import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/screens/user_details_screen/widgets/export.dart';
import 'package:mooncake/ui/ui.dart';

class MenuDrawer extends StatelessWidget {
  final User user;
  final List<MooncakeAccount> accounts;

  MenuDrawer({
    @required this.user,
    @required this.accounts,
  });

  List<Widget> _listAccounts() {
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
            },
          ),
        );
      },
    );

    return results;
  }

  @override
  Widget build(BuildContext context) {
    print("accounts");
    print(accounts);
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
                  color: Colors.white,
                ),
              ),
            ),
            ..._listAccounts(),
          ],
        ),
      ),
    );
  }
}
