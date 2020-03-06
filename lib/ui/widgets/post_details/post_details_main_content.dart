import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:mooncake/ui/ui.dart';

/// Represents the main content of the post details screen.
class PostDetailsMainContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final padding = PostsTheme.postItemPadding;
    return BlocBuilder<PostDetailsBloc, PostDetailsState>(
      builder: (BuildContext context, PostDetailsState state) {
        // ignore: close_sinks
        final bloc = BlocProvider.of<PostDetailsBloc>(context);

        // The post details are loaded
        final currentState = state as PostDetailsLoaded;
        final post = currentState.post;

        return DefaultTabController(
          length: 2,
          child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverList(
                  delegate: SliverChildListDelegate([
                    Container(padding: padding, child: PostContent(post: post)),
                    SizedBox(height: PostsTheme.defaultPadding),
                  ]),
                ),
                SliverAppBar(
                  elevation: 0,
                  primary: false,
                  backgroundColor: Colors.white,
                  leading: Container(),
                  pinned: true,
                  flexibleSpace: TabBar(
                    tabs: <Widget>[
                      Tab(text: "Comments"),
                      Tab(text: "Reactions"),
                    ],
                  ),
                )
              ];
            },
            body: TabBarView(
              children: <Widget>[
                CustomScrollView(
                  key: PageStorageKey<String>("comments"),
                  slivers: <Widget>[
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, i) => ListTile(
                          leading: CircleAvatar(
                            child: Text('0'),
                          ),
                          title: Text('Comment #$i'),
                        ),
                        childCount: 20,
                      ),
                    )
                  ],
                ),
                CustomScrollView(
                  key: PageStorageKey<String>("reactions"),
                  slivers: <Widget>[
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, i) => ListTile(
                          leading: CircleAvatar(
                            child: Text('0'),
                          ),
                          title: Text('Reaction #$i'),
                        ),
                        childCount: 20,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
