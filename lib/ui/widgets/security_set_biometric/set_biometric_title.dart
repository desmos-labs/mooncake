import 'package:flutter/material.dart';
import 'package:mooncake/ui/ui.dart';

/// Represents the title of the biometric setting screen.
class SetBiometricTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Flexible(
          child: Image(
            image: AssetImage("assets/icons/icon_ghost.png"),
          ),
        ),
        Text(
          PostsLocalizations.of(context).biometricsTitle,
          style: Theme.of(context)
              .textTheme
              .headline6
              .copyWith(color: Colors.white),
        ),
      ],
    );
  }
}
