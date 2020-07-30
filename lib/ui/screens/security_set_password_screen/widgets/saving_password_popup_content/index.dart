import 'package:flutter/material.dart';
import 'package:mooncake/ui/localization/export.dart';
import 'package:mooncake/ui/ui.dart';

/// Represents the content of the popup that is shown to the user
/// while the password he has chosen is being saved locally.
class SavingPasswordPopupContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          PostsLocalizations.of(context)
              .translate(Messages.savingPasswordTitle),
          style: Theme.of(context).textTheme.headline6,
        ),
        const SizedBox(height: 10),
        Text(
          PostsLocalizations.of(context).translate(Messages.savingPasswordBody),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            LoadingIndicator(),
          ],
        )
      ],
    );
  }
}
