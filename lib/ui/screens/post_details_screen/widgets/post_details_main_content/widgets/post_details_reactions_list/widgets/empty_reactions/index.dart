import 'package:flutter/material.dart';
import 'package:mooncake/ui/ui.dart';

class EmptyReactions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(child: Center()),
          Expanded(
            child: Center(
              child: Image.asset('assets/images/smile.png'),
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  PostsLocalizations.of(context)
                      .translate(Messages.noReactionsYet),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
