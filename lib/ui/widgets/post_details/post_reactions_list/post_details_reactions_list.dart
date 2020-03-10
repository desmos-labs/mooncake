import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/ui/ui.dart';

import 'post_details_reaction_item.dart';

/// Represents the list of all the reactions added to a post.
class PostReactionsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostDetailsBloc, PostDetailsState>(
      builder: (BuildContext context, PostDetailsState state) {
        if (state is PostDetailsLoading) {
          return Container();
        }

        final currentState = state as PostDetailsLoaded;
        return Container(
          padding: EdgeInsets.only(
            top: NestedScrollView.sliverOverlapAbsorberHandleFor(context)
                .layoutExtent,
          ),
          child: CustomScrollView(
            shrinkWrap: true,
            key: PageStorageKey<String>("reactions"),
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return PostReactionItem(
                      reaction: currentState.post.reactions[index],
                    );
                  },
                  childCount: currentState.post.reactions.length,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
