import 'package:desmosdemo/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Represents the text input that allows a user to input a mnemonic phrase
/// having a real time validation feedback.
/// The optional [verificationMnemonic] can be used in order to make sure
/// that the mnemonic phrase inserted by the user matches it.
class MnemonicInput extends StatefulWidget {
  final String verificationMnemonic;

  MnemonicInput({this.verificationMnemonic});

  @override
  _MnemonicInputState createState() => _MnemonicInputState();
}

class _MnemonicInputState extends State<MnemonicInput> {
  TextEditingController _textController = TextEditingController();
  MnemonicInputBloc _bloc;

  bool isRecoverButtonEnabled(MnemonicInputState state) {
    // If given, the state mnemonic should match the verification one
    bool mnemonicValid = widget.verificationMnemonic == null ||
        widget.verificationMnemonic == state.mnemonic;

    return state.isValid && mnemonicValid;
  }

  @override
  void initState() {
    _bloc = BlocProvider.of(context);
    _textController.addListener(_onMessageChanged);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MnemonicInputBloc, MnemonicInputState>(
      builder: (context, state) {
        return Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  controller: _textController,
                  key: PostsKeys.mnemonicField,
                  maxLines: null,
                  minLines: null,
                  autofocus: false,
                  expands: true,
                  autovalidate: true,
                  validator: (value) {
                    return !state.isEmpty && !isRecoverButtonEnabled(state)
                        ? PostsLocalizations.of(context).invalidMnemonic
                        : null;
                  },
                  decoration: InputDecoration(
                    hintText: PostsLocalizations.of(context).mnemonicHint,
                  ),
                  autocorrect: false,
                ),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _onMessageChanged() {
    _bloc.add(MnemonicChanged(_textController.text));
  }
}
