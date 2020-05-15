import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:url_launcher/url_launcher.dart';

/// Allows to view Mooncake terms and conditions
class LoginTermsAndConditions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyText2.copyWith(
          color: Colors.white,
          fontSize: 12,
        );

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: PostsLocalizations.of(context).termsDisclaimer,
            style: textStyle,
          ),
          WidgetSpan(child: const SizedBox(width: 4)),
          TextSpan(
            style: textStyle.copyWith(
              decoration: TextDecoration.underline,
            ),
            text: PostsLocalizations.of(context).termsAndConditions,
            recognizer: TapGestureRecognizer()..onTap = _onClick,
          ),
        ],
      ),
    );
  }

  void _onClick() async {
    final url = 'https://mooncake.space/eula';
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
}
