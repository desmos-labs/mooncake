import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/ui/ui.dart';

/// Represents the screen that is shown to the user when he wants
/// to visualize the details of a specific [postId].
class PostDetailsScreen extends StatelessWidget {
  final String postId;

  PostDetailsScreen({
    Key key,
    @required this.postId,
  })  : assert(postId != null),
        super(key: key ?? PostsKeys.postDetailsScreen(postId));

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PostDetailsBloc>(
      create: (context) => PostDetailsBloc.create(context, postId),
      child: BlocBuilder<PostDetailsBloc, PostDetailsState>(
        builder: (context, state) {
          // The post details are still loading
          if (state is LoadingPostDetails) {
            return Scaffold(
              appBar: AppBar(
                title: Text(PostsLocalizations.of(context).post),
              ),
              body: Container(
                decoration: PostsTheme.pattern,
                child: PostDetailsLoading(),
              ),
            );
          }

          return PostDetailsMainContent();
        },
      ),
    );
  }
}
