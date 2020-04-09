import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/ui/ui.dart';

import 'post_comments_list/export.dart';
import 'post_reactions_list/export.dart';
import 'post_details_bottom_bar/export.dart';

/// Represents the main content of the post details screen.
class PostDetailsMainContent extends StatefulWidget {
  @override
  _PostDetailsMainContentState createState() => _PostDetailsMainContentState();
}

class _PostDetailsMainContentState extends State<PostDetailsMainContent> {
  final indicator = new GlobalKey<RefreshIndicatorState>();
  Completer<void> _refreshCompleter;

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
  }

  @override
  Widget build(BuildContext ctx) {
    return RefreshIndicator(
      key: indicator,
      onRefresh: () {
        _refreshPost(ctx);
        return _refreshCompleter.future;
      },
      child: BlocBuilder<PostDetailsBloc, PostDetailsState>(
        builder: (BuildContext context, PostDetailsState postDetailsState) {
          final state = postDetailsState as PostDetailsLoaded;

          // Hide the refresh indicator
          if (!state.refreshing) {
            _refreshCompleter?.complete();
            _refreshCompleter = Completer();
          }

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
                            padding: PostsTheme.postItemPadding,
                            child: PostContent(post: state.post),
                          ),
                          SizedBox(height: PostsTheme.defaultPadding),
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
                                    .reactionsTabLabel(
                                        state.reactionsCount),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ];
                  },
                  body: TabBarView(
                    children: <Widget>[
                      PostCommentsList(comments: state.comments),
                      PostReactionsList(),
                    ],
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
      ),
    );
  }

  void _refreshPost(BuildContext context) {
    BlocProvider.of<PostDetailsBloc>(context).add(RefreshPostDetails());
  }
}
