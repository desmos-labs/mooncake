import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';

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
      onRefresh: () {
        // TODO: Implement the refresh of posts
        // BlocProvider.of<PostsListBloc>(context).add(RefreshPosts());
        return _refreshCompleter.future;
      },
      child: BlocBuilder<PostsListBloc, PostsListState>(
        bloc: BlocProvider.of<PostsListBloc>(context),
        builder: (context, state) {
          if (state is PostsLoaded) {
            // Hide the refresh indicator
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
                Flexible(
                  child: ListView.separated(
                    key: PostsKeys.postsList,
                    itemCount: posts.length,
                    separatorBuilder: (context, index) {
                      return Container(
                        height: 0.5,
                        color: ThemeColors.textColorLight,
                      );
                    },
                    itemBuilder: (context, index) {
                      return _postWidget(context, posts[index]);
                    },
                  ),
                ),
              ],
            );
          } else {
            return Container(
              key: PostsKeys.postsEmptyContainer,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  LoadingIndicator(),
                  SizedBox(height: 16),
                  Text(PostsLocalizations.of(context).loadingPosts)
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _postWidget(BuildContext buildContext, Post post) {
    return BlocProvider<PostListItemBloc>(
      create: (context) => PostListItemBloc.create(context, post),
      child: PostListItem(postId: post.id),
    );
  }
}
