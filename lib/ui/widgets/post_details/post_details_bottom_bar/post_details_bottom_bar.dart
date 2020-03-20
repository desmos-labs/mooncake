import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';

/// Represents the bottom bar that is shown inside the details of a post.
class PostDetailsBottomBar extends StatelessWidget {
  final double height;

  const PostDetailsBottomBar({
    Key key,
    @required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostDetailsBloc, PostDetailsState>(
      builder: (BuildContext context, PostDetailsState detailsState) {
        final state = detailsState as PostDetailsLoaded;
        return Container(
          height: height,
          width: MediaQuery.of(context).size.width,
          color: Theme.of(context).primaryColorDark,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                icon: Icon(MooncakeIcons.comment),
                onPressed: () => _commentClicked(context, state.post),
              ),
              IconButton(
                icon: Icon(state.isLiked
                    ? MooncakeIcons.heartFilled
                    : MooncakeIcons.heart),
                onPressed: () => _likeClicked(context),
              ),
              IconButton(
                icon: Icon(MooncakeIcons.addReaction),
                onPressed: () => _addReactionClicked(context),
              )
            ],
          ),
        );
      },
    );
  }

  void _commentClicked(BuildContext context, Post post) {
    BlocProvider.of<NavigatorBloc>(context).add(NavigateToCreatePost(post));
  }

  void _likeClicked(BuildContext context) {
    BlocProvider.of<PostDetailsBloc>(context).add(ToggleLike());
  }

  void _addReactionClicked(BuildContext context) {
    showEmojiPicker(
      context: context,
      onEmojiSelected: (emoji, _) {
        final code = getEmojiCode(emoji.emoji);
        BlocProvider.of<PostDetailsBloc>(context).add(ToggleReaction(code));
        BlocProvider.of<NavigatorBloc>(context).add(GoBack());
      },
    );
  }
}
