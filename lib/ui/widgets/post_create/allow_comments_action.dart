import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/ui/blocs/export.dart';
import 'package:mooncake/ui/localization/export.dart';
import 'package:mooncake/ui/ui.dart';

/// Represents the action that can be used to toggle between the possibility
/// of allowing comments to the post that is being created.
class AllowCommentAction extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostInputBloc, PostInputState>(
      builder: (context, state) {
        return Tooltip(
          message: state.allowsComments
              ? PostsLocalizations.of(context)
                  .createPostDisableCommentsButtonHint
              : PostsLocalizations.of(context)
                  .createPostEnableCommentsButtonHint,
          child: SecondaryRoundedButton(
            onPressed: () {
              BlocProvider.of<PostInputBloc>(context)
                  .add(ToggleAllowsComments());
            },
            borderRadius: BorderRadius.circular(100),
            color: state.allowsComments
                ? ThemeColors.textColorLight
                : Theme.of(context).accentColor,
            child: Text(state.allowsComments
                ? PostsLocalizations.of(context).createPostDisableCommentsButton
                : PostsLocalizations.of(context)
                    .createPostEnableCommentsButton),
          ),
        );
      },
    );
  }
}
