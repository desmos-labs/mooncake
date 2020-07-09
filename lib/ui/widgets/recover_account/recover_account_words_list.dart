import 'package:bip39/src/wordlists/english.dart' as english;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/ui/ui.dart';

/// Represents the horizontal list containing the words that can be selected.
class RecoverAccountWordsList extends StatelessWidget {
  final double height;

  const RecoverAccountWordsList({
    Key key,
    @required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecoverAccountBloc, RecoverAccountState>(
      builder: (BuildContext context, RecoverAccountState state) {
        final words = english.WORDLIST
            .where((word) => word.startsWith(state.typedWord))
            .toList();

        return Container(
          height: height,
          color: Theme.of(context).cardColor,
          padding: EdgeInsets.all(5),
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: words.length,
                  shrinkWrap: true,
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(width: 10);
                  },
                  itemBuilder: (BuildContext context, int index) {
                    final word = words[index];
                    return ActionChip(
                      elevation: 0,
                      pressElevation: 0,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      label: Text(
                        word,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () => _wordSelected(context, word),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _wordSelected(BuildContext context, String word) {
    BlocProvider.of<RecoverAccountBloc>(context).add(WordSelected(word));
  }
}
