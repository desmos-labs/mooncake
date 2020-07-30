import 'package:flutter/material.dart';
import 'package:mooncake/ui/ui.dart';

class BackupMnemonicDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: DefaultTextStyle.of(context).style,
          children: <TextSpan>[
            TextSpan(
                text: PostsLocalizations.of(context)
                    .translate(Messages.mnemonicViewBody1)),
            TextSpan(
                text: PostsLocalizations.of(context)
                    .translate(Messages.mnemonicViewBody2),
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(
                text: PostsLocalizations.of(context)
                    .translate(Messages.mnemonicViewBody3)),
          ],
        ),
      ),
    );
  }
}
