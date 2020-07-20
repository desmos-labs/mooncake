import 'package:flutter/material.dart';

/// Allows to display a single mnemonic word inside the list of words.
class MnemonicItem extends StatelessWidget {
  final int index;
  final String word;

  const MnemonicItem({
    Key key,
    @required this.index,
    @required this.word,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).accentColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Text(index.toString()),
          Expanded(child: Text(word, textAlign: TextAlign.center)),
        ],
      ),
    );
  }
}
