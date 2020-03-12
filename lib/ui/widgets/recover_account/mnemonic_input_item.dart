import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:bip39/src/wordlists/english.dart' as english;

/// Represents the input inside which the user will write a word of his
/// mnemonic code.
class MnemonicInputItem extends StatefulWidget {
  final index;

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
      builder: (BuildContext context, RecoverAccountState accountState) {
        final state = accountState as TypingMnemonic;

        if (state.currentWordIndex == widget.index) {
          FocusScope.of(context).requestFocus(_focusNode);
        }

        // Get the selected word, if existing
        final word = widget.index < state.wordsList.length
            ? state.wordsList[widget.index]
            : null;
        if (word != null) {
          _textEditingController.text = word;
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
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
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
    BlocProvider.of<RecoverAccountBloc>(context)
        .add(ChangeFocus(widget.index, _textEditingController.text));
  }

  void _emitText(String text) {
    BlocProvider.of<RecoverAccountBloc>(context).add(TypeWord(text));
  }
}