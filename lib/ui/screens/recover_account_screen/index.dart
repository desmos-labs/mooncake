import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/ui/ui.dart';

/// Screen that allows the user to recover the account from a mnemonic
/// phrase.
class RecoverAccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecoverAccountBloc, RecoverAccountState>(
      builder: (BuildContext context, RecoverAccountState state) {
        final bottomPadding = 50.0;
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(PostsLocalizations.of(context)
                .translate(Messages.recoverScreenTitle)),
          ),
          body: SafeArea(
            child: Stack(
              children: <Widget>[
                RecoverAccountMainContent(bottomPadding: bottomPadding),

                // Words list
                Positioned(
                  bottom: 0,
                  child: RecoverAccountWordsList(height: bottomPadding),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
