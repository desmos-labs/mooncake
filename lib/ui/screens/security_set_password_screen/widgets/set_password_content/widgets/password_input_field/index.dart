import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:mooncake/ui/screens/security_set_password_screen/blocs/export.dart';

/// Represents the input that is used from the user to insert a password.
class PasswordInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SetPasswordBloc, SetPasswordState>(
      builder: (BuildContext context, SetPasswordState state) {
        return Row(
          children: <Widget>[
            Expanded(
              child: TextFormField(
                keyboardType: TextInputType.visiblePassword,
                obscureText: !state.showPassword,
                maxLines: 1,
                onChanged: (pass) => _onPasswordChanged(context, pass),
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                      fontSize: 18,
                      color: Theme.of(context).accentColor,
                    ),
                decoration: InputDecoration(
                  hintText: PostsLocalizations.of(context)
                      .translate(Messages.passwordHint),
                  suffix: IconButton(
                    tooltip: state.showPassword
                        ? PostsLocalizations.of(context)
                            .translate(Messages.passwordHidePasswordButton)
                        : PostsLocalizations.of(context)
                            .translate(Messages.passwordShowPasswordButton),
                    icon: Icon(
                      state.showPassword
                          ? MooncakeIcons.eyeClose
                          : MooncakeIcons.eye,
                      color: Color(0xFF999999),
                    ),
                    onPressed: () => _switchPasswordVisibility(context),
                  ),
                  focusColor: Colors.red,
                  contentPadding: EdgeInsets.only(bottom: 4.0),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[600]),
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  void _onPasswordChanged(BuildContext context, String pass) {
    BlocProvider.of<SetPasswordBloc>(context).add(PasswordChanged(pass));
  }

  void _switchPasswordVisibility(BuildContext context) {
    BlocProvider.of<SetPasswordBloc>(context).add(TriggerPasswordVisibility());
  }
}
