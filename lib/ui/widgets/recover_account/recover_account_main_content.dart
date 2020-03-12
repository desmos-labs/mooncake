import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mooncake/ui/ui.dart';

import 'mnemonic_input_item.dart';

/// Represents the main content of the recover account screen.
class RecoverAccountMainContent extends StatelessWidget {
  final double bottomPadding;

  const RecoverAccountMainContent({
    Key key,
    @required this.bottomPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(
        top: 16,
        left: 16,
        bottom: bottomPadding + 16,
        right: 16,
      ),
      children: <Widget>[
        Text(
          PostsLocalizations.of(context).mnemonicRecoverInstructions,
          style: Theme.of(context).textTheme.bodyText2,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        StaggeredGridView.countBuilder(
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 2,
          itemCount: 24,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          staggeredTileBuilder: (count) => StaggeredTile.fit(1),
          itemBuilder: (BuildContext context, int index) {
            return MnemonicInputItem(index: index);
          },
        ),
      ],
    );
  }
}
