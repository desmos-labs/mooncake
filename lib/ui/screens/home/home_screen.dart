import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// HomeScreen is the main screen of the application, and the one from which
/// the user can access the posts timeline as well as other screens by
/// using the navigation bar
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, AppTab>(
      builder: (context, activeTab) {
        return Scaffold(
          appBar: AppBar(
            title: Text(PostsLocalizations.of(context).appTitle),
            actions: [
              IconButton(
                icon: Icon(FontAwesomeIcons.signOutAlt),
                onPressed: () {
                  BlocProvider.of<HomeBloc>(context).add(SignOut());
                },
                tooltip: PostsLocalizations.of(context).signOut,
              )
            ],
          ),
          body: activeTab == AppTab.posts
              ? PostsList(filter: (p) => !p.hasParent)
              : Account(),
          floatingActionButton: FloatingActionButton(
            key: PostsKeys.addPost,
            onPressed: () => Navigator.of(context).push(_createRoute()),
            child: Icon(Icons.add),
            tooltip: PostsLocalizations.of(context).editPost,
          ),
          bottomNavigationBar: TabSelector(
            activeTab: activeTab,
            onTabSelected: (tab) {
              BlocProvider.of<HomeBloc>(context).add(UpdateTab(tab));
            },
          ),
        );
      },
    );
  }

  Route _createRoute() {
    return MaterialPageRoute(builder: (BuildContext context) {
      return CreatePostScreen(callback: (_, message) {
        // ignore: close_sinks
        final bloc = BlocProvider.of<PostsBloc>(context);
        bloc.add(AddPost(parentId: null, message: message));
      });
    });
  }
}
