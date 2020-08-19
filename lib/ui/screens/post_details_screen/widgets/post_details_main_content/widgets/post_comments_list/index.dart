import 'package:flutter/material.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';

import 'widgets/export.dart';

/// Represents the list of comments that are associated to a specific post.
class PostCommentsList extends StatelessWidget {
  final List<Post> comments;

  const PostCommentsList({Key key, @required this.comments}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final childCount = (comments.length * 2) - 1;
    return Container(
      padding: EdgeInsets.only(
        top: NestedScrollView.sliverOverlapAbsorberHandleFor(context)
            .layoutExtent,
      ),
      child: comments.isEmpty
          ? _emptyCommentsContainer(context)
          : _commentsList(context, childCount),
    );
  }

  Widget _emptyCommentsContainer(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          SizedBox(height: 10),
          Expanded(
            child: Center(
              child: Image.asset("assets/images/smile.png", width: 150),
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  PostsLocalizations.of(context)
                      .translate(Messages.noCommentsYet),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _commentsList(BuildContext context, int childCount) {
    return CustomScrollView(
      shrinkWrap: true,
      key: PageStorageKey<String>("comments"),
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              if (index.isEven) {
                final comment = comments[index ~/ 2];
                return PostCommentItem(
                  key: PostsKeys.postCommentItem(comment.id),
                  comment: comment,
                );
              }

              return Container(height: 0.5, color: ThemeColors.textColorLight);
            },
            childCount: childCount,
          ),
        )
      ],
    );
  }
}
