import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/ui/ui.dart';

/// Represents the widget inside which all the users' account data
/// are displayed.
class AccountScreenContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, accountState) {
        final state = accountState as LoggedIn;
        return Container(
          child: AccountViewBody(user: state.user),
//      child: Column(
//        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//        children: <Widget>[
//          Text(
//            PostsLocalizations.of(context).accountPageTitle,
//            style: Theme.of(context).textTheme.headline6,
//            textAlign: TextAlign.center,
//          ),
//          Image.asset("assets/images/wink.png", width: 150),
//          Text(
//            PostsLocalizations.of(context)
//                .accountPageText
//                .replaceAll("\n", " "),
//            textAlign: TextAlign.center,
//          ),
//          FlatButton(
//            color: Theme.of(context).primaryColor,
//            child: Text(PostsLocalizations.of(context).editAccountButton),
//            onPressed: () {
//              BlocProvider.of<NavigatorBloc>(context)
//                  .add(NavigateToEditAccount());
//            },
//          )
//        ],
//      ),
        );
      },
    );
  }
}
