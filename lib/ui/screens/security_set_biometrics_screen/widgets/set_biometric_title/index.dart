import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:mooncake/ui/screens/security_set_biometrics_screen/blocs/export.dart';

/// Represents the title of the biometric setting screen.
class SetBiometricTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BiometricsBloc, BiometricsState>(
      builder: (context, state) {
        var icon = MooncakeIcons.fingerprint;
        if (state.availableBiometric == BiometricType.face) {
          icon = defaultTargetPlatform == TargetPlatform.iOS
              ? MooncakeIcons.faceId
              : MooncakeIcons.faceIdAndroid;
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              child: Icon(
                icon,
                size: MediaQuery.of(context).size.height * 0.3,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Text(
              PostsLocalizations.of(context)
                  .translate(Messages.biometricsTitle),
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(color: Colors.white),
            ),
          ],
        );
      },
    );
  }
}
