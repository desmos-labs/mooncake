import 'package:bip39/src/wordlists/english.dart' as english;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/ui/ui.dart';

/// Represents the input inside which the user will write a word of his
/// mnemonic code.
class MnemonicInputItem extends StatefulWidget {
  final int index;

  const MnemonicInputItem({
    Key key,
    @required this.index,
  }) : super(key: key);

  @override
  _MnemonicInputItemState createState() => _MnemonicInputItemState();
}

class _MnemonicInputItemState extends State<MnemonicInputItem> {
  final _focusNode = FocusNode();
  final _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecoverAccountBloc, RecoverAccountState>(
      builder: (BuildContext context, RecoverAccountState state) {
        // Get the selected word, if existing
        final word = state.wordsList[widget.index] ?? '';
        if (word != _textEditingController.text) {
          _textEditingController.text = word;
        }

        if (!state.isMnemonicComplete &&
            state.currentWordIndex == widget.index &&
            !_focusNode.hasFocus) {
          FocusScope.of(context).requestFocus(_focusNode);
        }

        // Find if the typed word is valid or not
        final currentText = _textEditingController.text;
        final isTextValid =
            currentText.isEmpty || english.WORDLIST.contains(currentText);

        return Container(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: isTextValid ? Colors.grey : Colors.red),
          ),
          child: Wrap(
            children: <Widget>[
              Row(
                children: <Widget>[
                  // Word index
                  Text(
                    (widget.index + 1).toString(),
                    style: Theme.of(context).textTheme.caption,
                  ),

                  // Spacer
                  SizedBox(width: 10),

                  // Input field
                  Expanded(
                    child: TextFormField(
                      onTap: _shiftFocus,
                      onChanged: _emitText,
                      focusNode: _focusNode,
                      controller: _textEditingController,
                      maxLines: 1,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(0.0),
                        isDense: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _shiftFocus() {
    if (!_focusNode.hasFocus) {
      BlocProvider.of<RecoverAccountBloc>(context)
          .add(ChangeFocus(widget.index, _textEditingController.text));
    }
  }

  void _emitText(String text) {
    BlocProvider.of<RecoverAccountBloc>(context)
        .add(TypeWord(widget.index, text));
  }
}
