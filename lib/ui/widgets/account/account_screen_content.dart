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
        );
      },
    );
  }
}
