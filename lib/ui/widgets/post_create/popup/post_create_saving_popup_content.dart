import 'package:flutter/material.dart';
import 'package:mooncake/ui/ui.dart';

class PostSavingPopupContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Icon(MooncakeIcons.syncing, color: ThemeColors.accentColor, size: 80),
        const SizedBox(height: 20),
        Text(
          PostsLocalizations.of(context).savingPostPopupBody,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Row(
          children: <Widget>[
            Expanded(
              child: PrimaryRoundedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                text: PostsLocalizations.of(context).savingPostPopupOkButton,
              ),
            ),
          ],
        )
      ],
    );
  }
}
