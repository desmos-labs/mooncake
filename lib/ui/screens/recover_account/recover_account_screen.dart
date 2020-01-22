import 'package:mooncake/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
            if (state is RecoveringAccount) _recoverLoading(context),
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
            onPressed:
                /*!state.mnemonicInputState.isValid
                ? null
                :*/
                () => _onRecoverPressed(context),
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

  Widget _recoverLoading(BuildContext context) {
    return Container(
      color: Color(0x90000000),
      child: Center(
        child: Card(
          elevation: 4,
          margin: EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  PostsLocalizations.of(context).recoverPopupTitle,
                  style: Theme.of(context).textTheme.title,
                ),
                SizedBox(height: 16),
                Text(PostsLocalizations.of(context).recoverPopupText),
                SizedBox(height: 16),
                SizedBox(
                  child: LoadingIndicator(),
                  width: 20,
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
