import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/localization/export.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:share/share.dart';

/// Represents the screen that allows the user to export his encrypted
/// mnemonic data.
class ExportMnemonicScreen extends StatelessWidget {
  final MnemonicData mnemonicData;

  const ExportMnemonicScreen({
    Key key,
    @required this.mnemonicData,
  }) : super(key: key);

  String get mnemonicText {
    return base64Encode(utf8.encode(jsonEncode(mnemonicData.toJson())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            PostsLocalizations.of(context).translate(Messages.exportMnemonic)),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              PostsLocalizations.of(context)
                  .translate(Messages.mnemonicExportScreenText)
                  .replaceAll('\n', ' '),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(mnemonicText),
            const SizedBox(height: 16),
            PrimaryButton(
              onPressed: () => _shareData(context),
              child: Text(PostsLocalizations.of(context)
                  .translate(Messages.mnemonicExportShareButton)),
            )
          ],
        ),
      ),
    );
  }

  void _shareData(BuildContext context) async {
    final text = PostsLocalizations.of(context)
        .translate(Messages.mnemonicExportShareText);
    await Share.share('$text\n\n$mnemonicText');
  }
}
