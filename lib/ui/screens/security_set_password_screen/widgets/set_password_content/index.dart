import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:mooncake/ui/screens/security_set_password_screen/blocs/export.dart';
import 'widgets/export.dart';
// import 'password_strength_indicator.dart';

/// Contains the content of the screen that allows the user to set
/// a custom password to protect its account.
class SetPasswordContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SetPasswordBloc, SetPasswordState>(
      builder: (BuildContext context, SetPasswordState state) {
        return ListView(
          padding: EdgeInsets.all(16),
          children: <Widget>[
            Text(
              PostsLocalizations.of(context)
                  .translate(Messages.passwordBody)
                  .replaceAll('\n', ' '),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 50),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                PasswordInputField(),
                const SizedBox(height: 16),
                if (state.passwordSecurity != PasswordSecurity.UNKNOWN)
                  PasswordStrengthIndicator(security: state.passwordSecurity),
                const SizedBox(height: 8),
                Text(
                  PostsLocalizations.of(context)
                      .translate(Messages.passwordCaption),
                  style: Theme.of(context).textTheme.caption,
                ),
              ],
            ),
            const SizedBox(height: 50),
            PrimaryButton(
              enabled: state.isPasswordValid,
              child: Text(PostsLocalizations.of(context)
                  .translate(Messages.passwordSaveButton)),
              onPressed: () => _onSavePassword(context),
            )
          ],
        );
      },
    );
  }

  void _onSavePassword(BuildContext context) {
    BlocProvider.of<SetPasswordBloc>(context).add(SavePassword());
  }
}
