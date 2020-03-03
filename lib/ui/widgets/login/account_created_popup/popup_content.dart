import 'package:flutter/material.dart';
import 'package:mooncake/ui/ui.dart';

class PopupContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.5,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Color(0xFF40318972), blurRadius: 15),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                PostsLocalizations.of(context)
                    .accountCreatedPopupTitleFirstRow
                    .toUpperCase(),
                style: TextThemes.loginPopupTitleTheme(context),
              ),
              Text(
                PostsLocalizations.of(context)
                    .accountCreatedPopupTitleSecondRow
                    .toUpperCase(),
                style: TextThemes.loginPopupTitleTheme(context),
              ),
              SizedBox(height: 10),
              Text(
                "You can backup your phrase later",
                style: TextThemes.loginPopupTextTheme(context),
              ),
              SizedBox(height: 50),
              Row(
                children: <Widget>[
                  Expanded(
                    child: PrimaryRoundedButton(
                      onPressed: () {},
                      text: PostsLocalizations.of(context)
                          .accountCreatedPopupMainButtonText,
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: SecondaryRoundedButton(
                      text: PostsLocalizations.of(context)
                          .accountCreatedPopupBackupButtonText,
                      onPressed: () {},
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
