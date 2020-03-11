import 'package:flutter/material.dart';
import 'package:mooncake/ui/ui.dart';

class CreatingAccountPopupContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          PostsLocalizations.of(context)
              .creatingAccountPopupTitle
              .toUpperCase(),
          style: TextThemes.loginPopupTitleTheme(context),
        ),
        SizedBox(height: 10),
        Text(
          PostsLocalizations.of(context).creatingAccountText,
          style: TextThemes.loginPopupTextTheme(context),
        ),
        SizedBox(height: 30),
        LoadingIndicator(),
      ],
    );
  }
}
