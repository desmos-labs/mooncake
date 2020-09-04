import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/ui/ui.dart';

/// Represents the content of the popup that is shown to the user
/// when a new account has been successfully created.
class AccountCreatedPopupContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).brightness == Brightness.light
        ? Theme.of(context).colorScheme.primary
        : Colors.white;
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          MooncakeIcons.success,
          size: 40,
          color: textColor,
        ),
        SizedBox(height: 15),
        Text(
          PostsLocalizations.of(context)
              .translate(Messages.accountCreatedPopupTitleFirstRow)
              .toUpperCase(),
          style: Theme.of(context).textTheme.headline6.copyWith(
                color: textColor,
              ),
        ),
        Text(
          PostsLocalizations.of(context)
              .translate(Messages.accountCreatedPopupTitleSecondRow)
              .toUpperCase(),
          style: Theme.of(context).textTheme.headline6.copyWith(
                color: textColor,
              ),
        ),
        SizedBox(height: 10),
        Text(
          PostsLocalizations.of(context)
              .translate(Messages.accountCreatedPopupText),
          style: TextStyle(
            color: textColor,
          ),
        ),
        SizedBox(height: 15),
        Row(
          children: <Widget>[
            Expanded(
              child: PrimaryButton(
                onPressed: () => _goToMooncake(context),
                child: Text(PostsLocalizations.of(context)
                    .translate(Messages.accountCreatedPopupMainButtonText)),
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
