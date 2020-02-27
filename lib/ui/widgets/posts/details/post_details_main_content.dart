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

        return Scaffold(
          body: SafeArea(
            child: NestedScrollView(
              headerSliverBuilder: (context, _) {
                return [
                  SliverAppBar(
                    backgroundColor: Colors.white,
                    expandedHeight: 310,
                    pinned: true,
                    primary: true,
                    flexibleSpace: PostContent(post: post),
                  )
                ];
              },
              body: ListView.builder(
                itemBuilder: (context, index) {
                  return Text(index.toString());
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
