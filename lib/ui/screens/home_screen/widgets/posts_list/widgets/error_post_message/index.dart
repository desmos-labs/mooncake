import 'package:flutter/material.dart';
import 'package:mooncake/ui/ui.dart';

class ErrorPostMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 10,
        right: 10,
        top: 15,
        bottom: 0,
      ),
      color: Theme.of(context).colorScheme.secondaryVariant,
      child: Text(
        PostsLocalizations.of(context).translate(Messages.postUploadError),
        textAlign: TextAlign.left,
        style: TextStyle(fontSize: 13, color: Colors.white),
      ),
    );
  }
}
