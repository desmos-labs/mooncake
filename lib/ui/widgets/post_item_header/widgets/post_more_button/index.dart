import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';
import 'widgets/export.dart';

/// Contains the available options for the popup that is opened when the
/// user wants to perform an additional option on a post.
enum PosOptions {
  Report,
  Hide,
  BlockUser,
}

/// Represents the button that allows to show more options about the post.
/// Such options include reporting the post, hiding the post or blocking the
/// user.
class PostMoreButton extends StatelessWidget {
  final double size;
  final Post post;

  const PostMoreButton({
    Key key,
    this.size = 16.0,
    @required this.post,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final icons = <PosOptions, IconData>{
      PosOptions.Report: MooncakeIcons.report,
      PosOptions.Hide: MooncakeIcons.eyeClose,
      PosOptions.BlockUser: MooncakeIcons.block,
    };

    final titles = <PosOptions, String>{
      PosOptions.Report: PostsLocalizations.of(context)
          .translate(Messages.postActionReportPost),
      PosOptions.Hide:
          PostsLocalizations.of(context).translate(Messages.postActionHide),
      PosOptions.BlockUser: PostsLocalizations.of(context)
          .translate(Messages.postActionBlockUser),
    };

    return PopupMenuButton<PosOptions>(
      onSelected: (value) => _onSelected(context, value),
      child: Icon(
        MooncakeIcons.more,
        size: size,
        color: Theme.of(context).colorScheme.primary.withOpacity(0.50),
      ),
      itemBuilder: (context) {
        return PosOptions.values.map((value) {
          return PopupMenuItem<PosOptions>(
            value: value,
            child: ListTile(
              leading: Icon(
                icons[value],
              ),
              title: Text(titles[value]),
            ),
          );
        }).toList();
      },
    );
  }

  /// Handles the given [value] when the user has selected the associated
  /// option from the created popup.
  void _onSelected(BuildContext context, PosOptions value) {
    switch (value) {
      case PosOptions.Report:
        showDialog(context: context, child: PostReportDialog(post: post));
        break;

      case PosOptions.Hide:
        BlocProvider.of<PostsListBloc>(context).add(HidePost(post));
        break;

      case PosOptions.BlockUser:
        showDialog(context: context, child: BlocUserDialog(user: post.owner));
        break;
    }
  }
}
