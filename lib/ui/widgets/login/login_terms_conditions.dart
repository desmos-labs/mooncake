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
            text: PostsLocalizations.of(context).terms,
            recognizer: TapGestureRecognizer()..onTap = _openTerms,
          ),
          WidgetSpan(child: const SizedBox(width: 4)),
          TextSpan(
            text: PostsLocalizations.of(context).and,
            style: textStyle,
          ),
          WidgetSpan(child: const SizedBox(width: 4)),
          TextSpan(
            style: textStyle.copyWith(
              decoration: TextDecoration.underline,
            ),
            text: PostsLocalizations.of(context).privacyPolicy,
            recognizer: TapGestureRecognizer()..onTap = _openPrivacy,
          ),
        ],
      ),
    );
  }

  void _openTerms() async {
    final url = 'https://mooncake.space/tos';
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  void _openPrivacy() async {
    final url = 'https://mooncake.space/privacy';
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
}
