import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';

import 'widgets/export.dart';

/// Represents the screen that allows to display the details of a given [user].
class UserDetailsScreen extends StatelessWidget {
  final User user;
  final bool isMyProfile;

  const UserDetailsScreen({
    Key key,
    @required this.user,
    @required this.isMyProfile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<PostsListBloc, PostsListState>(
        builder: (context, postsState) {
          List<Post> posts = [];
          if (postsState is PostsLoading) {
            posts = [];
          } else if (postsState is PostsLoaded) {
            posts = postsState.nonErroredPosts
                .where((post) => post.owner.address == user.address)
                .toList();
          }

          return NestedScrollView(
            physics: posts.isEmpty
                ? NeverScrollableScrollPhysics()
                : ScrollPhysics(),
            headerSliverBuilder: (BuildContext context, bool isBoxScrolled) {
              return <Widget>[
                AccountAppBar(
                  user: user,
                  isMyProfile: isMyProfile,
                  isFollower: false,
                ),
                SliverToBoxAdapter(
                  child: Container(
                    color: Theme.of(context).colorScheme.surface,
                    child: AccountNameRow(user: user, isMyProfile: isMyProfile),
                  ),
                ),
              ];
            },
            body: AccountPostsViewer(posts: posts),
          );
        },
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Drawer Header'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Item 1'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar:
          isMyProfile ? SafeArea(child: TabSelector()) : SizedBox.shrink(),
    );
  }
}
