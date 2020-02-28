import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/ui/ui.dart';

/// Represents the main content of the post details screen.
class PostDetailsMainContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostDetailsBloc, PostDetailsState>(
      builder: (BuildContext context, PostDetailsState state) {
        // The post details are loaded
        final currentState = state as PostDetailsLoaded;
        final post = currentState.post;

        return DefaultTabController(
          length: 2,
          child: ListView(
            children: <Widget>[
              PostContent(post: post),
              SizedBox(height: PostsTheme.defaultPadding),
              TabBar(
                unselectedLabelColor: Colors.grey[600],
                labelColor: Colors.black,
                tabs: [
                  Tab(text: "First"),
                  Tab(text: "Second"),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    Text("Test 2"),
                    Text("Test 2"),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
