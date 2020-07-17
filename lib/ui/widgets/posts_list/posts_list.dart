import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';

import 'posts_bottom_loader.dart';
import 'posts_list_loading_container.dart';
import 'posts_list_syncing_indicator.dart';

/// Represents a list of [Post] objects.
/// It simply builds a list using the [ListView.separated] builder
/// and the [PostListItem] class as the object representing each post.
class PostsList extends StatefulWidget {
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
          if (!state.refreshing) {
            _refreshCompleter?.complete();
            _refreshCompleter = Completer();
          }

          if (state.posts.isEmpty) {
            return PostsListEmptyContainer();
          }

          return Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  if (state.syncingPosts) PostsListSyncingIndicator(),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      key: PostsKeys.postsList,
                      itemCount: state.hasReachedMax
                          ? state.posts.length
                          : state.posts.length + 1,
                      itemBuilder: (context, index) {
                        return index >= state.posts.length
                            ? BottomLoader()
                            : PostListItem(post: state.posts[index]);
                      },
                      controller: _scrollController,
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
                      PostsLocalizations.of(context).refreshButtonText,
                    ),
                  ),
                ),
            ],
          );
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
}
