import 'package:mooncake/dependency_injection/dependency_injection.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/usecases/posts/posts.dart';

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
          final post =
              (postBloc.state as PostsLoaded).posts.firstBy(id: postId);
          return Scaffold(
            appBar: AppBar(
              title: Text(PostsLocalizations.of(context).post),
            ),
            body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/pattern.png"),
                  repeat: ImageRepeat.repeat,
                ),
              ),
              child: Column(
                children: <Widget>[
                  Flexible(
                    child: ListView(
                      children: <Widget>[
                        PostItem(
                          onTap: null,
                          postId: postId,
                          messageFontSize: 20,
                          key: PostsKeys.postDetails,
                        ),
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
      return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: comments.length,
        itemBuilder: (context, index) {
          final comment = comments[index];
          return PostItem(
            key: PostsKeys.postItem(comment.id),
            postId: comment.id,
            onTap: () async => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => PostDetailsScreen(postId: comment.id),
              ),
            ),
            margin: EdgeInsets.symmetric(horizontal: 26, vertical: 8),
          );
        },
      );
    }

    // Default case
    return Container();
  }

  /// Contains the input that allows a user to create a comment
  Widget _commentInput(BuildContext context) {
    return BlocBuilder<PostInputBloc, PostInputState>(
      builder: (context, state) => Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              PostForm(
                postId: postId,
                hint: PostsLocalizations.of(context).commentHint,
              ),
              RaisedButton(
                child: Text(PostsLocalizations.of(context).commentHint),
                onPressed: !state.isValid
                    ? null
                    : () => _submitComment(context, state),
              ),
              if (state.saving) LoadingIndicator()
            ],
          ),
        ),
      ),
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

  void _submitComment(BuildContext context, PostInputState state) async {
    // ignore: close_sinks
    final inputBloc = BlocProvider.of<PostInputBloc>(context);
    inputBloc.add(SavePost());

    // Create the comment
    final createUseCase = Injector.get<CreatePostUseCase>();
    final post = await createUseCase.create(
      message: state.message,
      parentId: postId,
      allowsComments: state.allowsComments,
    );

    final saveUseCase = Injector.get<SavePostUseCase>();
    await saveUseCase.save(post);

    // ignore: close_sinks
    final bloc = BlocProvider.of<PostsBloc>(context);
    bloc.add(AddPost(post));

    // Reset the state
    // ignore: close_sinks
    inputBloc.add(ResetForm());
  }
}
