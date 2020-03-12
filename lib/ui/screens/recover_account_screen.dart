import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/ui/ui.dart';

/// Represents the arguments that can be passed to a [RecoverAccountScreen].
class RecoverAccountArguments {
  /// Optional [mnemonic] that, when given, should match the one written
  /// by the user in order to consider this last one valid.
  final String mnemonic;

  RecoverAccountArguments({this.mnemonic});
}

/// Screen that allows the user to recover the account from a mnemonic
/// phrase.
class RecoverAccountScreen extends StatelessWidget {
  RecoverAccountScreen();

  @override
  Widget build(BuildContext context) {
    // TODO: Implement this again
    // RecoverAccountArguments args = ModalRoute.of(context).settings.arguments;
    // final String mnemonic = args?.mnemonic;

    return BlocBuilder<RecoverAccountBloc, RecoverAccountState>(
      builder: (context, state) {
        final bottomPadding = 50.0;
        return Stack(
          children: <Widget>[
            Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text(PostsLocalizations.of(context).recoverScreenTitle),
              ),
              body: BlocProvider(
                create: (context) => RecoverAccountBloc.create(context),
                child: Stack(
                  children: <Widget>[
                    RecoverAccountMainContent(bottomPadding: bottomPadding),
                    Positioned(
                      bottom: 0,
                      child: RecoverAccountWordsList(height: bottomPadding),
                    ),
                  ],
                ),
              ),
            ),

// TODO: Implement this again
//            if (state is RecoveringAccount)
//              RecoverPopup(
//                title: PostsLocalizations.of(context).recoveringPopupTitle,
//                message: PostsLocalizations.of(context).recoveringPopupText,
//                loading: true,
//              ),
//            if (state is RecoverError)
//              RecoverPopup(
//                title: PostsLocalizations.of(context).recoverPopupErrorTitle,
//                message: state.error.toString(),
//                loading: false,
//                onTap: () => _dismissErrorPopup(context),
//              )
          ],
        );
      },
    );
  }

  Widget _recoverButton(BuildContext context, TypingMnemonic state) {
    return Row(
      children: <Widget>[
        Expanded(
          child: RaisedButton(
            child: Text(PostsLocalizations.of(context).recoverAccount),
            onPressed: () => _onRecoverPressed(context),
          ),
        ),
      ],
    );
  }

  void _onRecoverPressed(BuildContext context) {
    // ignore: close_sinks
    final bloc = BlocProvider.of<RecoverAccountBloc>(context);
    bloc.add(RecoverAccount());
  }

  void _dismissErrorPopup(BuildContext context) {
    // ignore: close_sinks
    final bloc = BlocProvider.of<RecoverAccountBloc>(context);
    bloc.add(CloseErrorPopup());
  }
}
