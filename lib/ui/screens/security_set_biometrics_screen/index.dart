import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/ui/ui.dart';
import 'blocs/export.dart';
import 'widgets/export.dart';

/// Represents the screen that is shown to the user when he wants
/// to setup the biometric authentication for the application.
class SetBiometricScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<BiometricsBloc>(
      create: (context) {
        return BiometricsBloc.create(context)..add(CheckAuthenticationType());
      },
      child: BlocBuilder<BiometricsBloc, BiometricsState>(
        builder: (context, state) => Scaffold(
          body: Stack(
            children: <Widget>[
              Container(
                decoration: ThemeDecorations.pattern(context),
                constraints: BoxConstraints.expand(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    AppBar(
                      title: Text('Access account'),
                      centerTitle: true,
                      backgroundColor: Colors.transparent,
                      iconTheme: IconThemeData(color: Colors.white),
                      textTheme: Theme.of(context).textTheme.copyWith(
                          headline6:
                              Theme.of(context).textTheme.headline6.copyWith(
                                    color: Colors.white,
                                  )),
                    ),
                    Flexible(child: SetBiometricTitle()),
                    Flexible(child: SetBiometricBody())
                  ],
                ),
              ),
              if (state.saving)
                GenericPopup(
                  backgroundColor: Colors.white.withOpacity(0.5),
                  content: SavingBiometricsPopupContent(),
                )
            ],
          ),
        ),
      ),
    );
  }
}
