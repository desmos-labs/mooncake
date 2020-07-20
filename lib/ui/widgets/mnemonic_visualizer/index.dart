import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'widgets/export.dart';

/// Allows to visualize the mnemonic that the user has previously either
/// inserted himself or created from scratch.
class MnemonicVisualizer extends StatelessWidget {
  final List<String> mnemonic;
  final bool allowExport;
  final bool backupPhrase;
  const MnemonicVisualizer({
    Key key,
    @required this.mnemonic,
    this.allowExport = true,
    this.backupPhrase = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (backupPhrase) BackupMnemonicDetails(),
        StaggeredGridView.countBuilder(
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 3,
          itemCount: 24,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          staggeredTileBuilder: (index) => StaggeredTile.fit(1),
          itemBuilder: (BuildContext context, int index) {
            return MnemonicItem(index: index + 1, word: mnemonic[index]);
          },
        ),
        if (allowExport) ExportMnemonicButton(),
        if (backupPhrase) BackupMnemonicButton()
      ],
    );
  }
}
