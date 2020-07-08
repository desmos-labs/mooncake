import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:crypto/crypto.dart';

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
          title: Text(PostsLocalizations.of(context).viewMnemonic),
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
                                    .securityLoginText
                                    .replaceAll("\n", ""),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                PostsLocalizations.of(context)
                                    .securityLoginWarning
                                    .replaceAll("\n", ""),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                PostsLocalizations.of(context)
                                    .securityLoginPassword
                                    .replaceAll("\n", ""),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              _passwordInput(context),
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

  Widget _passwordInput(BuildContext context) {
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
            hintText: PostsLocalizations.of(context).passwordHint,
          ),
        ),
        const SizedBox(height: 16),
        PrimaryButton(
          onPressed: () => _viewMnemonic(context),
          enabled: enableButton,
          child: Text(PostsLocalizations.of(context).viewMnemonic),
        ),
      ],
    );
  }

  bool _isPasswordCorrect(String password) {
    return widget.hashedPassword ==
        sha256.convert(utf8.encode(password)).toString();
  }

  void _viewMnemonic(BuildContext context) {
    BlocProvider.of<MnemonicBloc>(context).add(ShowMnemonic());
  }
}
