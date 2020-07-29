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
              .translate("accountCreatedPopupTitleFirstRow")
              .toUpperCase(),
          style: Theme.of(context).textTheme.headline6.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        Text(
          PostsLocalizations.of(context)
              .translate("accountCreatedPopupTitleSecondRow")
              .toUpperCase(),
          style: Theme.of(context).textTheme.headline6.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        SizedBox(height: 10),
        Text(PostsLocalizations.of(context)
            .translate("accountCreatedPopupText")),
        SizedBox(height: 25),
        Row(
          children: <Widget>[
            Expanded(
              child: PrimaryButton(
                onPressed: () => _goToMooncake(context),
                child: Text(PostsLocalizations.of(context)
                    .translate("accountCreatedPopupMainButtonText")),
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
