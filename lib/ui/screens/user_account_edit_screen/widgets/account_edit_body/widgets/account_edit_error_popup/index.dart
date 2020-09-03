import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:mooncake/ui/screens/user_account_edit_screen/blocs/export.dart';

/// Represents the popup that is displayed to the user when an error during
/// the editing of the profile is emitted.
class AccountEditErrorPopup extends StatelessWidget {
  final String error;

  const AccountEditErrorPopup({Key key, @required this.error})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(PostsLocalizations.of(context)
          .translate(Messages.saveAccountErrorPopupTitle)),
      actions: [
        FlatButton(
          onPressed: () => _hidePopup(context),
          child:
              Text(PostsLocalizations.of(context).translate(Messages.dismiss)),
        )
      ],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: ThemeSpaces.smallMargin),
          Text(
            PostsLocalizations.of(context)
                .translate(Messages.saveAccountErrorPopupBody)
                .replaceAll('\n', ' '),
          ),
          const SizedBox(height: ThemeSpaces.smallMargin),
          Text(error),
        ],
      ),
    );
  }

  void _hidePopup(BuildContext context) {
    BlocProvider.of<EditAccountBloc>(context).add(HideErrorPopup());
  }
}
