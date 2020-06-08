import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/ui/ui.dart';

import 'post_comments_list/export.dart';
import 'post_details_bottom_bar/export.dart';
import 'post_reactions_list/export.dart';

/// Represents the main content of the post details screen.
class PostDetailsMainContent extends StatelessWidget {
  @override
  Widget build(BuildContext ctx) {
    return BlocBuilder<PostDetailsBloc, PostDetailsState>(
      builder: (BuildContext context, PostDetailsState postDetailsState) {
        final state = postDetailsState as PostDetailsLoaded;

        final bottomBarHeight = 50.0;
        return DefaultTabController(
          length: 2,
          child: Stack(
            children: <Widget>[
              NestedScrollView(
                headerSliverBuilder: (BuildContext context, bool _) {
                  return [
                    // Post content
                    SliverList(
                      delegate: SliverChildListDelegate([
                        Container(
                          padding: EdgeInsets.all(12.0),
                          child: PostContent(post: state.post),
                        ),
                        SizedBox(height: ThemeSpaces.smallGutter),
                      ]),
                    ),
                    // Tab bar
                    SliverOverlapAbsorber(
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                        context,
                      ),
                      sliver: SliverAppBar(
                        elevation: 0,
                        primary: false,
                        stretch: true,
                        floating: false,
                        leading: Container(),
                        pinned: true,
                        flexibleSpace: TabBar(
                          labelColor: Theme.of(context).accentColor,
                          unselectedLabelColor: Colors.grey[500],
                          indicatorSize: TabBarIndicatorSize.label,
                          tabs: <Widget>[
                            Tab(
                              text: PostsLocalizations.of(context)
                                  .commentsTabLabel(state.commentsCount),
                            ),
                            Tab(
                              text: PostsLocalizations.of(context)
                                  .reactionsTabLabel(state.reactionsCount),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ];
                },
                body: Padding(
                  padding: EdgeInsets.only(bottom: bottomBarHeight),
                  child: TabBarView(
                    children: <Widget>[
                      PostCommentsList(comments: state.comments),
                      PostReactionsList(),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: PostDetailsBottomBar(height: bottomBarHeight),
              ),
            ],
          ),
        );
      },
    );
  }
}
