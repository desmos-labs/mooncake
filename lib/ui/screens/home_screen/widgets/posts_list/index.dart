import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';
import 'widgets/export.dart';

/// Represents a list of [Post] objects.
/// It simply builds a list using the [ListView.separated] builder
/// and the [PostListItem] class as the object representing each post.
class PostsList extends StatefulWidget {
  final User user;

  const PostsList({Key key, @required this.user}) : super(key: key);

  @override
  _PostsListState createState() => _PostsListState();
}

class _PostsListState extends State<PostsList> {
  final _indicator = GlobalKey<RefreshIndicatorState>();
  Completer<void> _refreshCompleter;

  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  PostsListBloc _postsListBloc;

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();

    _scrollController.addListener(_onScroll);
    _postsListBloc = BlocProvider.of<PostsListBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: _indicator,
      onRefresh: () {
        _refreshPosts(context);
        return _refreshCompleter.future;
      },
      child: BlocBuilder<PostsListBloc, PostsListState>(
        builder: (context, postsState) {
          // Posts are not loaded, return the empty container
          if (!(postsState is PostsLoaded)) {
            return PostsLoadingEmptyContainer();
          }

          // Hide the refresh indicator
          final state = postsState as PostsLoaded;
          var erroredPosts = state.erroredPosts
              .where((post) => post.owner.address == widget.user.address)
              .toList();
          var posts = state.nonErroredPosts;

          if (!state.refreshing) {
            _refreshCompleter?.complete();
            _refreshCompleter = Completer();
          }

          if (posts.isEmpty) {
            return PostsListEmptyContainer();
          }

          return BlocBuilder<HomeBloc, HomeState>(
              builder: (context, homeState) {
            _validateBackToTopStatus(homeState);
            return Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    if (state.syncingPosts) PostsListSyncingIndicator(),
                    Expanded(
                      child: CustomScrollView(
                        controller: _scrollController,
                        slivers: [
                          if (erroredPosts.isNotEmpty)
                            SliverList(
                              delegate: SliverChildListDelegate(
                                [ErrorPostMessage()],
                              ),
                            ),
                          if (erroredPosts.isNotEmpty)
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                                  return ErrorPost(
                                      post: erroredPosts[index],
                                      lastChild:
                                          index + 1 == erroredPosts.length);
                                },
                                childCount: erroredPosts.length,
                              ),
                            ),
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                return index >= posts.length
                                    ? BottomLoader()
                                    : PostListItem(post: posts[index]);
                              },
                              childCount: state.hasReachedMax
                                  ? posts.length
                                  : posts.length + 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (state.shouldRefresh)
                  Align(
                    alignment: Alignment.topCenter,
                    child: FlatButton(
                      textColor: Colors.white,
                      color: Theme.of(context).colorScheme.secondary,
                      onPressed: () {
                        _indicator.currentState.show();
                      },
                      child: Text(
                        PostsLocalizations.of(context)
                            .translate(Messages.refreshButtonText),
                      ),
                    ),
                  ),
              ],
            );
          });
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _refreshPosts(BuildContext context) {
    BlocProvider.of<PostsListBloc>(context).add(RefreshPosts());
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      _postsListBloc.add(FetchPosts());
    }
  }

  void _backToTop() {
    _scrollController.animateTo(
      0.0,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
  }

  void _validateBackToTopStatus(HomeState homeState) {
    if (!_scrollController.hasClients) {
      return null;
    }
    final shouldScroll =
        homeState.activeTab == AppTab.home && homeState.scrollToTop;
    // If position is at top refresh posts otherwise scroll to top
    if (_scrollController.position.pixels == 0.0 && shouldScroll) {
      _indicator.currentState.show();
    } else if (shouldScroll) {
      BlocProvider.of<HomeBloc>(context).add(SetScrollToTop(false));
      _backToTop();
    }
  }
}
