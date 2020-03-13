import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/ui/ui.dart';

/// Represents the screen that is shown to the user when he wants
/// to setup the biometric authentication for the application.
class SetBiometricScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<BiometricsBloc>(
      create: (context) => BiometricsBloc.create(context),
      child: Builder(
        builder: (context) => Scaffold(
          body: Container(
            padding: EdgeInsets.all(16),
            color: ThemeColors.accentColor,
            constraints: BoxConstraints.expand(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                AppBar(
                  title: Text("Access account"),
                  centerTitle: true,
                  backgroundColor: Colors.transparent,
                ),
                Flexible(child: SetBiometricTitle()),
                Flexible(child: SetBiometricBody())
              ],
            ),
          ),
        ),
      ),
    );
  }
}
