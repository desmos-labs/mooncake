import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Material(
            color: Colors.transparent,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                PostCommentAction(post: state.post),
                PostAddReactionAction(post: state.post),
              ],
            ),
          ),
        );
      },
    );
  }
}
