import 'package:flutter/material.dart';
import 'package:mooncake/ui/ui.dart';

class MnemonicBackupPopup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GenericPopup(
      backgroundColor: Colors.black54,
      width: MediaQuery.of(context).size.width -
          (MediaQuery.of(context).size.width * 0.25),
      content: Container(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Text(
                PostsLocalizations.of(context).mnemonicBackupBody1,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            SizedBox(height: 10),
            Text(
              PostsLocalizations.of(context).mnemonicBackupBody2,
            ),
            PrimaryButton(
              child: Text(
                PostsLocalizations.of(context).mnemonicBackupButton,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.button.copyWith(
                      color: Colors.white,
                    ),
              ),
              onPressed: () => null,
            ),
          ],
        ),
      ),
    );
  }
}
