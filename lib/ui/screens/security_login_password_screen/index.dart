import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/ui/ui.dart';

/// Allows the user to view his mnemonic phrase after inputting the same
/// password that he had chosen while setting up the account.
class LoginWithPasswordScreen extends StatefulWidget {
  /// Represents the hashed password of the user.
  final String hashedPassword;
  final bool backupPhrase;

  const LoginWithPasswordScreen({
    Key key,
    @required this.hashedPassword,
    this.backupPhrase = false,
  }) : super(key: key);

  @override
  _LoginWithPasswordScreenState createState() =>
      _LoginWithPasswordScreenState();
}

class _LoginWithPasswordScreenState extends State<LoginWithPasswordScreen> {
  bool enableButton = false;

  @override
  void initState() {
    print(widget.hashedPassword);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
              PostsLocalizations.of(context).translate(Messages.viewMnemonic)),
        ),
        body: BlocProvider(
          create: (context) => MnemonicBloc.create(context),
          child: BlocBuilder<MnemonicBloc, MnemonicState>(
            builder: (context, state) {
              return Stack(
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    child: state.showMnemonic
                        ? MnemonicVisualizer(
                            mnemonic: state.mnemonic,
                            allowExport: widget.backupPhrase ? false : true,
                            backupPhrase: widget.backupPhrase,
                          )
                        : ListView(
                            children: [
                              Text(
                                PostsLocalizations.of(context)
                                    .translate(Messages.securityLoginText)
                                    .replaceAll('\n', ' '),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                PostsLocalizations.of(context)
                                    .translate(Messages.securityLoginWarning)
                                    .replaceAll('\n', ' '),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                PostsLocalizations.of(context)
                                    .translate(Messages.securityLoginPassword)
                                    .replaceAll('\n', ' '),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              CheckBoxButton(
                                value: state.hasCheckedBox,
                                child: Expanded(
                                  child: Text(
                                    PostsLocalizations.of(context).translate(
                                        Messages.understoodMnemonicDisclaimer),
                                  ),
                                ),
                                onChanged: (_) => _checkBoxChanged(context),
                              ),
                              const SizedBox(height: 16),
                              _passwordInput(state, context),
                            ],
                          ),
                  ),
                  // Exporting popup
                  if (state is ExportingMnemonic) ExportMnemonicPopup(),
                ],
              );
            },
          ),
        ));
  }

  void _checkBoxChanged(BuildContext context) {
    BlocProvider.of<MnemonicBloc>(context).add(ToggleCheckBox());
  }

  Widget _passwordInput(MnemonicState state, BuildContext context) {
    return Column(
      children: [
        TextField(
          autofocus: true,
          keyboardType: TextInputType.visiblePassword,
          obscureText: true,
          onChanged: (value) => setState(() {
            enableButton = _isPasswordCorrect(value);
          }),
          decoration: InputDecoration(
            hintText:
                PostsLocalizations.of(context).translate(Messages.passwordHint),
          ),
        ),
        const SizedBox(height: 16),
        PrimaryButton(
          onPressed: () => _viewMnemonic(context),
          enabled: state.hasCheckedBox && enableButton,
          child: Text(
              PostsLocalizations.of(context).translate(Messages.viewMnemonic)),
        ),
      ],
    );
  }

  bool _isPasswordCorrect(String password) {
    return widget.hashedPassword ==
        sha256.convert(utf8.encode(password)).toString();
  }

  void _viewMnemonic(BuildContext context) {
    final user = (BlocProvider.of<AccountBloc>(context).state as LoggedIn).user;
    BlocProvider.of<MnemonicBloc>(context).add(ShowMnemonic(user.address));
  }
}
