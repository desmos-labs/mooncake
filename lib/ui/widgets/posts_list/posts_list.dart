import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';

import 'posts_list_syncing_indicator.dart';
import 'posts_list_empty_container.dart';

typedef Filter = bool Function(Post);

/// Represents a list of [Post] objects.
/// It simply builds a list using the [ListView.separated] builder
/// and the [PostListItem] class as the object representing each post.
class PostsList extends StatefulWidget {
  @override
  _PostsListState createState() => _PostsListState();
}

class _PostsListState extends State<PostsList> {
  Completer<void> _refreshCompleter;

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        _refreshPosts(context);
        return _refreshCompleter.future;
      },
      child: BlocBuilder<PostsListBloc, PostsListState>(
        builder: (context, postsState) {
          // Posts are not loaded, return the empty container
          if (!(postsState is PostsLoaded)) {
            return PostsListEmptyContainer();
          }

          // Hide the refresh indicator
          final state = postsState as PostsLoaded;
          if (!state.refreshing) {
            _refreshCompleter?.complete();
            _refreshCompleter = Completer();
          }

          return Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  PostsListSyncingIndicator(visible: state.syncingPosts),
                  Expanded(
                    child: ListView.builder(
                      key: PostsKeys.postsList,
                      itemCount: state.posts.length,
                      itemBuilder: (context, index) {
                        final post = state.posts[index];
                        return PostListItem(post: post);
                      },
                    )
                  ),
                ],
              ),
              if (state.shouldRefresh)
                Align(
                  alignment: Alignment.topCenter,
                  child: FlatButton(
                    textColor: Colors.white,
                    color: Theme.of(context).iconTheme.color,
                    onPressed: () => _refreshPosts(context),
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

  void _refreshPosts(BuildContext context) {
    BlocProvider.of<PostsListBloc>(context).add(RefreshPosts());
  }
}
