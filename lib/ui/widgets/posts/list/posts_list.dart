import 'package:dwitter/entities/entities.dart';
import 'package:dwitter/ui/ui.dart';
import 'package:dwitter/ui/widgets/posts/list/fetching_snackbar.dart';
import 'package:dwitter/ui/widgets/posts/list/sync_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bottom_loader.dart';

typedef Filter = bool Function(Post);

/// Represents a list of [Post] objects.
/// It simply builds a list using the [ListView.separated] builder
/// and the [PostItem] class as the object representing each post.
class PostsList extends StatefulWidget {
  final Filter _filter;

  PostsList({Key key, Filter filter})
      : _filter = filter,
        super(key: key);

  @override
  _PostsListState createState() => _PostsListState();
}

class _PostsListState extends State<PostsList> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  PostsBloc _postsBloc;

  @override
  void initState() {
    _scrollController.addListener(_onScroll);
    _postsBloc = BlocProvider.of<PostsBloc>(context)..add(LoadPosts());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostsBloc, PostsState>(
      bloc: _postsBloc,
      builder: (context, state) {
        if (state is PostsLoading) {
          return LoadingIndicator(key: PostsKeys.postsLoading);
        } else if (state is PostsLoaded) {
          // Filter the posts based on the filter set
          final posts = state.posts
              .where((p) => widget._filter != null ? widget._filter(p) : true)
              .toList();
          return Column(
            children: <Widget>[
              Flexible(
                child: ListView.separated(
                  key: PostsKeys.postsList,
                  controller: _scrollController,
                  itemCount: state.isLoadingNewPage
                      ? posts.length + 1
                      : posts.length,
                  separatorBuilder: (context, index) => Divider(height: 1),
                  itemBuilder: (context, index) {
                    return index >= posts.length
                        ? BottomLoader()
                        : _postWidget(context, posts[index]);
                  },
                ),
              ),
              if (state.syncingPosts) SyncSnackBar(),
              if (state.fetchingPosts) FetchingSnackbar(),
            ],
          );
        } else {
          return Container(key: PostsKeys.postsEmptyContainer);
        }
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll < _scrollThreshold) {
      _postsBloc.add(LoadPosts(nextPage: true));
    }
  }

  Widget _postWidget(BuildContext context, Post post) {
    return PostItem(
      postId: post.id,
      onTap: () async => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => PostDetailsScreen(postId: post.id),
        ),
      ),
    );
  }
}
