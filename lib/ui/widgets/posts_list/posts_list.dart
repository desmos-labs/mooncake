import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';

import 'posts_list_syncing_indicator.dart';
import 'posts_list_empty_container.dart';
import 'posts_list_content.dart';

typedef Filter = bool Function(Post);

/// Represents a list of [Post] objects.
/// It simply builds a list using the [ListView.separated] builder
/// and the [PostListItem] class as the object representing each post.
class PostsList extends StatefulWidget {
  final Filter _filter;

  PostsList({Key key, Filter filter})
      : _filter = filter,
        super(key: key);

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
      // TODO: Implement the refresh of posts
      // BlocProvider.of<PostsListBloc>(context).add(RefreshPosts());
      onRefresh: () {
        return Future.value();
      },
      child: BlocBuilder<PostsListBloc, PostsListState>(
        bloc: BlocProvider.of<PostsListBloc>(context),
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

          // Filter the posts based on the filter set
          final posts = state.posts
              .where((p) => widget._filter?.call(p) ?? true)
              .toList();

          return Column(
            children: <Widget>[
              if (state.syncingPosts) PostsListSyncingIndicator(),
              Expanded(child: PostsListContent(posts: posts)),
            ],
          );
        },
      ),
    );
  }
}
