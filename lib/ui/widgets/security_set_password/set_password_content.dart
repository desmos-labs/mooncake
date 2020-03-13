import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:mooncake/ui/widgets/security_set_password/password_strength_indicator.dart';

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
            Text(PostsLocalizations.of(context).passwordBody),
            const SizedBox(height: 50),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        maxLines: 1,
                        onChanged: (pass) => _onPasswordChanged(context, pass),
                        decoration: InputDecoration(
                          hintText: PostsLocalizations.of(context).passwordHint,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 8),
                if (state.passwordSecurity != PasswordSecurity.UNKNOWN)
                  PasswordStrengthIndicator(security: state.passwordSecurity),
                const SizedBox(height: 8),
                Text(
                  PostsLocalizations.of(context).passwordCaption,
                  style: Theme.of(context).textTheme.caption,
                ),
              ],
            ),
            const SizedBox(height: 50),
            PrimaryRoundedButton(
              enabled: state.isPasswordValid,
              text: PostsLocalizations.of(context).passwordSaveButton,
              onPressed: () => _onSavePassword(context),
            )
          ],
        );
      },
    );
  }

  void _onSavePassword(BuildContext context) {
    // TODO: Do something
  }

  void _onPasswordChanged(BuildContext context, String pass) {
    BlocProvider.of<SetPasswordBloc>(context).add(PasswordChanged(pass));
  }
}
