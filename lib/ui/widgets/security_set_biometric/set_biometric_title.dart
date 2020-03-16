import 'package:flutter/material.dart';
import 'package:mooncake/ui/ui.dart';

/// Represents the title of the biometric setting screen.
class SetBiometricTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
          child: Image(
            height: MediaQuery.of(context).size.height * 0.3,
            image: AssetImage("assets/images/fingerprint.png"),
          ),
        ),
        SizedBox(height: 20),
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
