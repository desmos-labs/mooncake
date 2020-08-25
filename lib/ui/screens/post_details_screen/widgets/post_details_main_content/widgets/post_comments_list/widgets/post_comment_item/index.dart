import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';

/// Represents single item entry inside the list of post comments.
class PostCommentItem extends StatelessWidget {
  static const ICON_SIZE = 20.0;

  final Post comment;
  PostCommentItem({Key key, @required this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
        builder: (BuildContext context, AccountState accountState) {
      final state = accountState as LoggedIn;
      final isLiked = state.user.hasLiked(comment);

      return InkWell(
        onTap: () => _onTap(context),
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              PostItemHeader(post: comment),
              const SizedBox(height: ThemeSpaces.smallGutter),
              if (comment.message?.isNotEmpty == true) _textWidget(),
              PostImagesPreviewer(post: comment),
              const SizedBox(height: ThemeSpaces.smallGutter),
              _commentActions(isLiked),
            ],
          ),
        ),
      );
    });
  }

  Widget _textWidget() {
    return Column(
      children: [
        PostMessage(post: comment),
        const SizedBox(height: ThemeSpaces.smallGutter),
      ],
    );
  }

  Row _commentActions(bool isLiked) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        PostCommentAction(size: ICON_SIZE, post: comment),
        const SizedBox(width: ICON_SIZE),
        PostAddReactionAction(size: ICON_SIZE, post: comment),
      ],
    );
  }

  void _onTap(BuildContext context) {
    BlocProvider.of<NavigatorBloc>(context)
        .add(NavigateToPostDetails(comment.id));
  }
}
