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
    RecoverAccountArguments args = ModalRoute.of(context).settings.arguments;
    final String mnemonic = args?.mnemonic;

    return BlocBuilder<RecoverAccountBloc, RecoverAccountState>(
      builder: (context, state) {
        return Stack(
          children: <Widget>[
            Scaffold(
              appBar: AppBar(
                title: Text("Recover mnemonic"),
              ),
              body: Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      PostsLocalizations.of(context)
                          .mnemonicRecoverInstructions,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: MnemonicInput(verificationMnemonic: mnemonic),
                    ),
                    const SizedBox(height: 16),
                    if (state is TypingMnemonic) _recoverButton(context, state),
                  ],
                ),
              ),
            ),
            if (state is RecoveringAccount)
              RecoverPopup(
                title: PostsLocalizations.of(context).recoveringPopupTitle,
                message: PostsLocalizations.of(context).recoveringPopupText,
                loading: true,
              ),
            if (state is RecoverError)
              RecoverPopup(
                title: PostsLocalizations.of(context).recoverPopupErrorTitle,
                message: state.error.toString(),
                loading: false,
                onTap: () => _dismissErrorPopup(context),
              )
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
