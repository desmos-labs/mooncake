import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/ui/ui.dart';

import 'post_comment_item.dart';

/// Represents the list of comments that are associated to a specific post.
class PostCommentsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostDetailsBloc, PostDetailsState>(
      builder: (BuildContext context, PostDetailsState state) {
        if (state is PostDetailsLoading) {
          return Container();
        }

        final currentState = state as PostDetailsLoaded;
        if (currentState.comments.isEmpty) {
          return Container();
        }

        final childCount = currentState.comments.length +
            (currentState.comments.length / 2).ceil() -
            1;

        return Container(
          padding: EdgeInsets.only(
            top: NestedScrollView.sliverOverlapAbsorberHandleFor(context)
                .layoutExtent,
          ),
          child: CustomScrollView(
            shrinkWrap: true,
            key: PageStorageKey<String>("comments"),
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    if (index.isEven) {
                      return BlocProvider<PostListItemBloc>(
                        create: (context) => PostListItemBloc.create(
                          context,
                          currentState.comments[index],
                        ),
                        child: PostCommentItem(),
                      );
                    }

                    return Container(
                      height: 0.5,
                      color: ThemeColors.textColorLight,
                    );
                  },
                  semanticIndexCallback: (Widget widget, int localIndex) {
                    if (localIndex.isEven) {
                      return localIndex ~/ 2;
                    }
                    return null;
                  },
                  childCount: childCount,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
