import 'package:flutter/material.dart';
import 'package:mooncake/ui/ui.dart';

/// Represents the content of the
class SavingBiometricsPopupContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          PostsLocalizations.of(context)
              .translate(Messages.savingBiometricsTitle),
          style: Theme.of(context).textTheme.headline6,
        ),
        const SizedBox(height: 10),
        Text(PostsLocalizations.of(context)
            .translate(Messages.savingBiometricsBody)),
        const SizedBox(height: 20),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            LoadingIndicator(),
          ],
        ),
      ],
    );
  }
}
