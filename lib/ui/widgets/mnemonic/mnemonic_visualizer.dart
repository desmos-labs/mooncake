import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mooncake/ui/ui.dart';

import 'mnemonic_item.dart';

/// Allows to visualize the mnemonic that the user has previously either
/// inserted himself or created from scratch.
class MnemonicVisualizer extends StatelessWidget {
  final bool allowExport;
  final bool backupPhrase;
  const MnemonicVisualizer({
    Key key,
    this.allowExport = true,
    this.backupPhrase = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MnemonicBloc, MnemonicState>(
      builder: (context, state) {
        return Column(
          children: [
            if (backupPhrase)
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      TextSpan(
                          text:
                              PostsLocalizations.of(context).mnemonicViewBody1),
                      TextSpan(
                          text:
                              PostsLocalizations.of(context).mnemonicViewBody2,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(
                          text:
                              PostsLocalizations.of(context).mnemonicViewBody3),
                    ],
                  ),
                ),
              ),
            StaggeredGridView.countBuilder(
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 3,
              itemCount: 24,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              staggeredTileBuilder: (index) => StaggeredTile.fit(1),
              itemBuilder: (BuildContext context, int index) {
                return MnemonicItem(
                    index: index + 1, word: state.mnemonic[index]);
              },
            ),
            if (allowExport) ExportMnemonicButton(),
            if (backupPhrase) BackupMnemonicButton()
          ],
        );
      },
    );
  }
}
