import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';

import 'popup_report/popup_report.dart';

/// Represents the popup that allows a user to perform some actions related
/// to a post such as reporting it.
class PostOptionsPopup extends StatelessWidget {
  final Post post;
  const PostOptionsPopup({
    Key key,
    @required this.post,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 150,
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Text(
              PostsLocalizations.of(context).postActionsPopupTitle,
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 8),
            _buildItem(
              context: context,
              icon: MooncakeIcons.report,
              text: PostsLocalizations.of(context).postActionReportPost,
              action: () => _onReportClicked(context),
            ),
            _buildItem(
              context: context,
              icon: MooncakeIcons.eyeClose,
              text: PostsLocalizations.of(context).postActionHide,
              action: () => _onHideClicked(context),
            ),
            _buildItem(
              context: context,
              icon: MooncakeIcons.block,
              text: PostsLocalizations.of(context).postActionBlockUser,
              action: () => _onBlockUserClicked(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem({
    BuildContext context,
    IconData icon,
    String text,
    Function action,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: action,
        child: Container(
          padding: EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Icon(icon, color: Theme.of(context).textTheme.bodyText2.color),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  text,
                  style: Theme.of(context).textTheme.bodyText2,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onReportClicked(BuildContext context) {
    Navigator.pop(context);
    showDialog(
      context: context,
      child: BlocProvider<ReportPopupBloc>(
        create: (_) => ReportPopupBloc.create(post),
        child: ReportPostPopup(post: post),
      ),
    );
  }

  void _onHideClicked(BuildContext context) {
    Navigator.pop(context);
    BlocProvider.of<PostsListBloc>(context).add(HidePost(post));
  }

  void _onBlockUserClicked(BuildContext context) {
    Navigator.pop(context);
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Block user?"),
            content: Text(
                "By blocking ${post.owner.address} you will no longer see his posts. Would you like to continue?"),
            actions: [
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancel"),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                  BlocProvider.of<PostsListBloc>(context)
                      .add(BlockUser(post.owner));
                },
                child: Text("Block"),
              ),
            ],
          );
        });
  }
}
