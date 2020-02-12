import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/ui/ui.dart';

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
                    return (state.isEmpty || state.isValid)
                        ? null
                        : PostsLocalizations.of(context).invalidMnemonic;
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
    _bloc.add(MnemonicChanged(
      insertedMnemonic: _textController.text,
      verificationMnemonic: widget.verificationMnemonic,
    ));
  }
}
