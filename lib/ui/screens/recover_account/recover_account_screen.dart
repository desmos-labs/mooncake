import 'package:desmosdemo/ui/ui.dart';
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
        return Scaffold(
          appBar: AppBar(
            title: Text("Recover mnemonic"),
          ),
          body: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  PostsLocalizations.of(context).mnemonicRecoverInstructions,
                ),
                SizedBox(height: 16),
                Expanded(
                  child: MnemonicInput(verificationMnemonic: mnemonic),
                ),
                SizedBox(height: 16),
                if (state is TypingMnemonic) _recoverButton(context, state),
                if (state is RecoveringAccount) _recoverLoading(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _recoverButton(BuildContext context, TypingMnemonic state) {
    return Row(
      children: <Widget>[
        Expanded(
          child: FlatButton(
            color: PostsTheme.accentColor,
            child: Text(PostsLocalizations.of(context).recoverAccount),
            onPressed: !state.mnemonicInputState.isValid
                ? null
                : () => _onRecoverPressed(context),
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

  Widget _recoverLoading() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: 16,
          width: 16,
          child: LoadingIndicator(),
        ),
        SizedBox(width: 16),
        Text("Recovering account...")
      ],
    );
  }
}
