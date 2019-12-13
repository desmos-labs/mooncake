import 'package:dwitter/entities/entities.dart';
import 'package:dwitter/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return MultiBlocProvider(
      providers: [
        BlocProvider<PostCommentsBloc>(
          create: (context) => PostCommentsBloc.create(BlocProvider.of(context))
            ..add(LoadPostComments(postId)),
        ),
        BlocProvider<PostInputBloc>(
          create: (context) => PostInputBloc(),
        ),
      ],
      child: BlocBuilder<PostCommentsBloc, PostCommentsState>(
        builder: (context, state) {
          // ignore: close_sinks
          final postBloc = BlocProvider.of<PostsBloc>(context);
          final post = (postBloc.state as PostsLoaded).posts.firstBy(id: postId);
          return Scaffold(
            appBar: AppBar(
              title: Text(PostsLocalizations.of(context).post),
            ),
            body: Padding(
              padding: EdgeInsets.all(0),
              child: Column(
                children: <Widget>[
                  Flexible(
                    child: ListView(
                      children: <Widget>[
                        PostDetails(key: PostsKeys.postDetails, postId: postId),
                        const Divider(height: 1),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: PostActionsBar(postId: postId),
                        ),
                        const Divider(height: 1),
                        _comments(state),
                      ],
                    ),
                  ),
                  post.allowsComments
                      ? _commentInput(context)
                      : _commentDisabled(context),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Represents the part of the screen that displays the list of comments
  Widget _comments(PostCommentsState state) {
    // The comments are being loaded
    if (state is PostCommentsLoading) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: LoadingIndicator(),
      );
    }

    // The comments have been loaded properly
    else if (state is PostCommentsLoaded) {
      final comments = state.comments;
      return ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: comments.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          // Build the comment item
          final comment = comments[index];
          return PostItem(
            postId: comment.id,
            onTap: () async => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => PostDetailsScreen(postId: comment.id),
              ),
            ),
          );
        },
      );
    }

    // Default case
    return Container();
  }

  /// Contains the input that allows a user to create a comment
  Widget _commentInput(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: PostForm(
            postId: postId,
            hint: PostsLocalizations.of(context).commentHint,
          ),
        ),
        BlocBuilder<PostInputBloc, PostInputState>(
          builder: (context, state) => RaisedButton(
            child: Text(PostsLocalizations.of(context).commentHint),
            onPressed:
                !state.isValid ? null : () => _submitComment(context, state),
          ),
        )
      ],
    );
  }

  /// Contains the text telling the user that he cannot post a comment
  Widget _commentDisabled(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        PostsLocalizations.of(context).commentsDisabled,
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  void _submitComment(BuildContext context, PostInputState state) {
    // Create the comment
    // ignore: close_sinks
    final bloc = BlocProvider.of<PostsBloc>(context);
    bloc.add(AddPost(message: state.message, parentId: postId));

    // Reset the state
    // ignore: close_sinks
    final inputBloc = BlocProvider.of<PostInputBloc>(context);
    inputBloc.add(ResetForm());
  }
}
