import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';
import 'blocs/export.dart';
import 'widgets/export.dart';

/// Represents the dialog that is presented to the user when he wants to
/// report a post.
class PostReportDialog extends StatelessWidget {
  final Post post;

  const PostReportDialog({Key key, @required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ReportPopupBloc>(
      create: (_) => ReportPopupBloc.create(post),
      child: ReportPostPopup(post: post),
    );
  }
}

/// Represents the dialog that is presented to the user when he wants to
/// block another user.
class BlocUserDialog extends StatelessWidget {
  final User user;

  const BlocUserDialog({Key key, @required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
          PostsLocalizations.of(context).translate(Messages.blockDialogTitle)),
      content: Text(
          '${PostsLocalizations.of(context).translate(Messages.blockDialogTextOne)} ${user.address} ${PostsLocalizations.of(context).translate(Messages.blockDialogTextTwo)}'),
      actions: [
        FlatButton(
          child: Text(PostsLocalizations.of(context)
              .translate(Messages.blockDialogCancelButton)),
          onPressed: () => Navigator.pop(context),
        ),
        FlatButton(
          child: Text(PostsLocalizations.of(context)
              .translate(Messages.blockDialogBlockButton)),
          onPressed: () {
            Navigator.pop(context);
            BlocProvider.of<PostsListBloc>(context).add(BlockUser(user));
          },
        ),
      ],
    );
  }
}
