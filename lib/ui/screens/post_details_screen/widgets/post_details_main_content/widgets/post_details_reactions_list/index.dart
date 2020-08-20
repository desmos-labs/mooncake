import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/ui/ui.dart';
import 'widgets/export.dart';

/// Represents the list of all the reactions added to a post.
class PostDetailsReactionsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostDetailsBloc, PostDetailsState>(
      builder: (BuildContext context, PostDetailsState state) {
        if (state is LoadingPostDetails) {
          return Container();
        }

        final currentState = state as PostDetailsLoaded;
        return Container(
            padding: EdgeInsets.only(
              top: NestedScrollView.sliverOverlapAbsorberHandleFor(context)
                  .layoutExtent,
            ),
            child: currentState.reactionsCount == 0
                ? EmptyReactions()
                : ReactionsList(post: currentState.post));
      },
    );
  }
}
