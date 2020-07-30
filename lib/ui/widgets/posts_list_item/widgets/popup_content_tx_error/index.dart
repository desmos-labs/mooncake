import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/ui/ui.dart';

/// Represents the content of the popup that is shown to the user when he
/// long clicks a post that has been included into a transaction later
/// marked as unsuccessful.
class PostErrorPopupContent extends StatelessWidget {
  final String error;

  const PostErrorPopupContent({
    Key key,
    @required this.error,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          PostsLocalizations.of(context).translate(Messages.syncErrorTitle),
          style: Theme.of(context).textTheme.headline6,
        ),
        const SizedBox(height: 16),
        Text(PostsLocalizations.of(context).translate(Messages.syncErrorDesc)),
        const SizedBox(height: 16),
        Text(error),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FlatButton(
              child: Text(PostsLocalizations.of(context)
                  .translate(Messages.syncErrorCopyButton)),
              onPressed: () => _copyError(context),
            )
          ],
        )
      ],
    );
  }

  void _copyError(BuildContext context) {
    Clipboard.setData(ClipboardData(text: error)).then((_) {
      BlocProvider.of<NavigatorBloc>(context).add(GoBack());
    });
  }
}
