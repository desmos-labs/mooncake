import 'package:flutter/material.dart';
import 'package:mooncake/ui/ui.dart';

/// Allows to easily visualize how strong an input password is.
class PasswordStrengthIndicator extends StatelessWidget {
  final height = 4.0;
  final spacer = 4.0;
  final PasswordSecurity security;

  const PasswordStrengthIndicator({
    Key key,
    @required this.security,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var text = '';
    var textColor = Colors.transparent;
    if (security == PasswordSecurity.LOW) {
      text = PostsLocalizations.of(context)
          .translate(Messages.passwordSecurityLow);
      textColor = Colors.red;
    } else if (security == PasswordSecurity.MEDIUM) {
      text = PostsLocalizations.of(context)
          .translate(Messages.passwordSecurityMedium);
      textColor = Colors.orange;
    } else if (security == PasswordSecurity.HIGH) {
      text = PostsLocalizations.of(context)
          .translate(Messages.passwordSecurityHigh);
      textColor = Colors.green;
    }

    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            color: security != PasswordSecurity.UNKNOWN
                ? Colors.red
                : Colors.transparent,
            height: height,
          ),
        ),
        SizedBox(width: spacer),
        Expanded(
          child: Container(
            color: security == PasswordSecurity.MEDIUM ||
                    security == PasswordSecurity.HIGH
                ? Colors.orange
                : Colors.transparent,
            height: height,
          ),
        ),
        SizedBox(width: spacer),
        Expanded(
          child: Container(
            color: security == PasswordSecurity.HIGH
                ? Colors.green
                : Colors.transparent,
            height: height,
          ),
        ),
        SizedBox(width: spacer),
        Expanded(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodyText2
                .copyWith(color: textColor),
          ),
        )
      ],
    );
  }
}
