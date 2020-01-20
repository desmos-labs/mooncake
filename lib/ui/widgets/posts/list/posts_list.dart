import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:mooncake/ui/widgets/posts/list/fetching_snackbar.dart';
import 'package:mooncake/ui/widgets/posts/list/sync_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef Filter = bool Function(Post);

/// Represents a list of [Post] objects.
/// It simply builds a list using the [ListView.separated] builder
/// and the [PostItem] class as the object representing each post.
class PostsList extends StatelessWidget {
  final Filter _filter;

  PostsList({Key key, Filter filter})
      : _filter = filter,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/images/pattern.png"),
            repeat: ImageRepeat.repeat),
      ),
      child: BlocBuilder<PostsBloc, PostsState>(
        bloc: BlocProvider.of<PostsBloc>(context)..add(LoadPosts()),
        builder: (context, state) {
          if (state is PostsLoading) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(PostsLocalizations.of(context).splashLoadingData),
                LoadingIndicator(key: PostsKeys.postsLoading),
              ],
            );
          } else if (state is PostsLoaded) {
            // Filter the posts based on the filter set
            final posts = state.posts
                .where((p) => _filter != null ? _filter(p) : true)
                .toList();
            return Column(
              children: <Widget>[
                Flexible(
                  child: ListView.builder(
                    key: PostsKeys.postsList,
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      return _postWidget(context, posts[index]);
                    },
                  ),
                ),
                if (state.syncingPosts) SyncSnackBar(),
              ],
            );
          } else {
            return Container(key: PostsKeys.postsEmptyContainer);
          }
        },
      ),
    );
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
