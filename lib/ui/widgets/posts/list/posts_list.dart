import 'package:desmosdemo/entities/entities.dart';
import 'package:desmosdemo/ui/ui.dart';
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
    return BlocBuilder<PostsBloc, PostsState>(
      bloc: BlocProvider.of<PostsBloc>(context)..add(LoadPosts()),
      builder: (context, state) {
        if (state is PostsLoading) {
          return LoadingIndicator(key: PostsKeys.postsLoading);
        } else if (state is PostsLoaded) {
          // Filter the posts based on the filter set
          final posts = state.posts
              .where((p) => _filter != null ? _filter(p) : true)
              .toList();
          return Column(
            children: <Widget>[
              Flexible(
                child: ListView.separated(
                  key: PostsKeys.postsList,
                  itemCount: posts.length,
                  separatorBuilder: (context, index) => Divider(height: 1),
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    return PostItem(
                      postId: post.id,
                      onTap: () async => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => PostDetailsScreen(postId: post.id),
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (state.showSnackbar) _syncSnackbar(context),
            ],
          );
        } else {
          return Container(key: PostsKeys.postsEmptyContainer);
        }
      },
    );
  }

  Widget _syncSnackbar(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.orange,
      child: Row(
        children: <Widget>[
          Icon(FontAwesomeIcons.cloudUploadAlt, size: 16),
          SizedBox(width: 16),
          Text(PostsLocalizations.of(context).syncingActivities),
        ],
      ),
    );
  }
}
