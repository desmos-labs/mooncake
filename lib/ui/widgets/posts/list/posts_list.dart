import 'package:desmosdemo/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Represents a list of [Post] objects.
/// It simply builds a list using the [ListView.separated] builder
/// and the [PostItem] class as the object representing each post.
class PostsList extends StatelessWidget {
  PostsList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostsBloc, PostsState>(
      builder: (context, state) {
        if (state is PostsLoading) {
          return LoadingIndicator(key: PostsKeys.postsLoading);
        } else if (state is PostsLoaded) {
          final posts = state.posts.where((p) => !p.hasParent).toList();
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
          Text(FlutterBlocLocalizations.of(context).syncingActivities),
        ],
      ),
    );
  }
}
