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
            decoration: ThemeDecorations.pattern,
            constraints: BoxConstraints.expand(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                AppBar(
                  title: Text("Access account"),
                  centerTitle: true,
                  backgroundColor: Colors.transparent,
                  iconTheme: IconThemeData(color: Colors.white),
                  textTheme: Theme.of(context).textTheme.copyWith(
                    headline6: Theme.of(context).textTheme.headline6.copyWith(
                      color: Colors.white,
                    )
                  ),
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
