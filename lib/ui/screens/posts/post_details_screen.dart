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
    return Scaffold(
      appBar: AppBar(
        title: Text(PostsLocalizations.of(context).postDetailsTitle),
      ),
      body: Container(
        color: Colors.white,
        padding: PostsTheme.postItemPadding,
        child: BlocProvider<PostDetailsBloc>(
          create: (context) => PostDetailsBloc.create(context, postId),
          child: BlocBuilder<PostDetailsBloc, PostDetailsState>(
            builder: (context, state) {
              if (state is LoadingPostDetails) {
                return PostDetailsLoading();
              }

              return PostDetailsMainContent();
            },
          ),
        ),
      ),
    );
  }
}
