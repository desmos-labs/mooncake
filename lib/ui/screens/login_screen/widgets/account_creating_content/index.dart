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
          style: Theme.of(context).accentTextTheme.headline6,
        ),
        SizedBox(height: 10),
        Text(
          PostsLocalizations.of(context)
              .translate(Messages.creatingAccountText),
          style: Theme.of(context).accentTextTheme.headline6,
        ),
        SizedBox(height: 30),
        LoadingIndicator(),
      ],
    );
  }
}
