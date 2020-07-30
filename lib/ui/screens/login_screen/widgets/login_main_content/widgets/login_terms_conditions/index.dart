import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:url_launcher/url_launcher.dart';

/// Allows to view Mooncake terms and conditions
class LoginTermsAndConditions extends StatelessWidget {
  final TextAlign align;

  LoginTermsAndConditions({this.align = TextAlign.start});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyText2.copyWith(
          color: Colors.white,
          fontSize: 12,
        );

    return RichText(
      textAlign: align,
      text: TextSpan(
        children: [
          TextSpan(
            text: PostsLocalizations.of(context)
                .translate(Messages.termsDisclaimer),
            style: textStyle,
          ),
          WidgetSpan(child: const SizedBox(width: 4)),
          TextSpan(
            style: textStyle.copyWith(
              decoration: TextDecoration.underline,
            ),
            text: PostsLocalizations.of(context).translate(Messages.terms),
            recognizer: TapGestureRecognizer()..onTap = _openTerms,
          ),
          WidgetSpan(child: const SizedBox(width: 4)),
          TextSpan(
            text: PostsLocalizations.of(context).translate(Messages.and),
            style: textStyle,
          ),
          WidgetSpan(child: const SizedBox(width: 4)),
          TextSpan(
            style: textStyle.copyWith(
              decoration: TextDecoration.underline,
            ),
            text: PostsLocalizations.of(context)
                .translate(Messages.privacyPolicy),
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
