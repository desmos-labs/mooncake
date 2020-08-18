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
              .translate(Messages.creatingAccountPopupTitle)
              .toUpperCase(),
          style: Theme.of(context)
              .textTheme
              .headline6
              .copyWith(color: Theme.of(context).colorScheme.primary),
        ),
        SizedBox(height: 10),
        Text(
          PostsLocalizations.of(context)
              .translate(Messages.creatingAccountText),
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        SizedBox(height: 30),
        LoadingIndicator(color: Theme.of(context).colorScheme.secondaryVariant),
      ],
    );
  }
}
