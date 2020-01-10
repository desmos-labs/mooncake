import 'package:dwitter/ui/blocs/account/account_bloc.dart';
import 'package:dwitter/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Represents the widget inside which all the users' account data
/// are displayed.
class Account extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      bloc: AccountBloc.create()..add(LoadAccount()),
      builder: (context, state) {
        if (state is UninitializedAccount) {
          return Container();
        } else if (state is LoadingAccount) {
          return Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              LoadingIndicator(),
            ],
          );
        }

        final currentState = state as AccountLoaded;

        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    PostsLocalizations.of(context).accountTitle,
                    style: PostsTheme.theme.textTheme.title,
                  )
                ],
              ),
              SizedBox(height: 8),
              Text(
                PostsLocalizations.of(context).yourAddress,
                style: PostsTheme.theme.textTheme.subtitle,
              ),
              Text(currentState.address),
            ],
          ),
        );
      },
    );
  }
}
