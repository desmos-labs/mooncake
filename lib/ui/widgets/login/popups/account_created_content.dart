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
          style: TextThemes.loginPopupTitleTheme(context),
        ),
        Text(
          PostsLocalizations.of(context)
              .accountCreatedPopupTitleSecondRow
              .toUpperCase(),
          style: TextThemes.loginPopupTitleTheme(context),
        ),
        SizedBox(height: 10),
        Text(
          "You can backup your phrase later",
          style: TextThemes.loginPopupTextTheme(context),
        ),
        SizedBox(height: 50),
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
        Row(
          children: <Widget>[
            Expanded(
              child: SecondaryRoundedButton(
                text: PostsLocalizations.of(context)
                    .accountCreatedPopupBackupButtonText,
                onPressed: () {},
              ),
            ),
          ],
        )
      ],
    );
  }

  void _goToMooncake(BuildContext context) {
    BlocProvider.of<AccountBloc>(context).add(LogIn());
  }
}
