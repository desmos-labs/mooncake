import 'package:dwitter/ui/localization/export.dart';
import 'package:dwitter/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Represents the screen that is seen from the user when he wants
/// to generate a new random mnemonic.
class GenerateMnemonicScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenerateMnemonicBloc, GenerateMnemonicState>(
      bloc: BlocProvider.of(context)..add(GenerateMnemonic()),
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(PostsLocalizations.of(context).createAccount),
            actions: <Widget>[
              IconButton(
                icon: Icon(FontAwesomeIcons.redoAlt),
                onPressed: () => _refreshMnemonic(context),
              )
            ],
          ),
          body: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                (state is MnemonicGenerated)
                    ? _mnemonicBody(context, state)
                    : _loadingMnemonic(context),
                RaisedButton(
                  child: Text(PostsLocalizations.of(context).mnemonicWritten),
                  onPressed: (state is MnemonicGenerated)
                      ? () => _mnemonicWrittenClicked(context)
                      : null,
                )
              ],
            ),
          ),
        );
      },
    );
  }

  /// Returns the widget that displays the mnemonic
  Widget _mnemonicBody(BuildContext context, MnemonicGenerated state) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Text(PostsLocalizations.of(context).generatedMnemonicText),
          SizedBox(height: 16),
          Flexible(
            child: ListView(
              children: [
                Wrap(
                  runSpacing: 8,
                  spacing: 8,
                  children: List.generate(state.mnemonic.length, (index) {
                    return MnemonicItem(
                      index: index + 1,
                      word: state.mnemonic[index],
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Returns the widgets that is shown while loading the mnemonic
  Widget _loadingMnemonic(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(PostsLocalizations.of(context).generatingMnemonic),
          SizedBox(height: 16),
          Expanded(
            child: LoadingIndicator(),
          ),
        ],
      ),
    );
  }

  void _refreshMnemonic(BuildContext context) {
    // ignore: close_sinks
    final bloc = BlocProvider.of<GenerateMnemonicBloc>(context);
    bloc.add(GenerateMnemonic());
  }

  void _mnemonicWrittenClicked(BuildContext context) {
    // ignore: close_sinks
    final bloc = BlocProvider.of<GenerateMnemonicBloc>(context);
    bloc.add(MnemonicWritten());
  }
}
