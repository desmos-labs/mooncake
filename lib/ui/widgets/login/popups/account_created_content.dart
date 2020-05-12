import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/ui/ui.dart';

/// Represents the content of the popup that is shown to the user
/// when a new account has been successfully created.
class AccountCreatedPopupContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          PostsLocalizations.of(context)
              .accountCreatedPopupTitleFirstRow
              .toUpperCase(),
          style: Theme.of(context).accentTextTheme.headline6,
        ),
        Text(
          PostsLocalizations.of(context)
              .accountCreatedPopupTitleSecondRow
              .toUpperCase(),
          style: Theme.of(context).accentTextTheme.headline6,
        ),
        SizedBox(height: 10),
        Text(
          PostsLocalizations.of(context).accountCreatedPopupText,
          style: Theme.of(context).accentTextTheme.bodyText2,
        ),
        SizedBox(height: 25),
        Row(
          children: <Widget>[
            Expanded(
              child: PrimaryRoundedButton(
                onPressed: () => _goToMooncake(context),
                text: PostsLocalizations.of(context)
                    .accountCreatedPopupMainButtonText,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _goToMooncake(BuildContext context) {
    BlocProvider.of<NavigatorBloc>(context).add(NavigateToProtectAccount());
  }
}
