import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';

class AccountInfoViewer extends StatelessWidget {
  final User user;

  const AccountInfoViewer({Key key, @required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, state) {
        final account = (state as LoggedIn).user;
        return Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    user.screenName,
                    style: Theme.of(context).textTheme.headline6.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.address,
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              ),
            ),

            // If the user is the owner of the app, show the wallet button
            if (account.address == user.address)
              PrimaryButton(
                onPressed: () => _navigateToWallet(context),
                child: Text(PostsLocalizations.of(context).walletButtonTooltip),
                expanded: false,
                borderRadius: 100,
              ),
          ],
        );
      },
    );
  }

  void _navigateToWallet(BuildContext context) {
    BlocProvider.of<NavigatorBloc>(context).add(NavigateToWallet());
  }
}
