import 'package:desmosdemo/blocs/blocs.dart';
import 'package:desmosdemo/dependency_injection/export.dart';
import 'package:desmosdemo/keys.dart';
import 'package:desmosdemo/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../localization.dart';

/// Represents the screen that is shown to the user when he wants
/// to visualize the details of a specific [postId].
class DetailsScreen extends StatelessWidget {
  final String postId;

  DetailsScreen({
    Key key,
    @required this.postId,
  })  : assert(postId != null),
        super(key: key ?? PostsKeys.postDetailsScreen(postId));

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PostCommentsBloc>(
          builder: (context) => PostCommentsBloc(
            postsBloc: BlocProvider.of(context),
            repository: Injector.get(),
          )..add(LoadPostComments(postId)),
        ),
        BlocProvider<PostInputBloc>(
          builder: (context) => PostInputBloc(),
        ),
      ],
      child: BlocBuilder<PostCommentsBloc, PostCommentsState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(FlutterBlocLocalizations.of(context).post),
            ),
            body: Padding(
              padding: EdgeInsets.all(0),
              child: Column(
                children: <Widget>[
                  _body(state),
                  _commentInput(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _body(PostCommentsState state) {
    return Flexible(
      child: ListView(
        children: <Widget>[
          PostDetails(
            key: PostsKeys.postDetails,
            postId: postId,
          ),
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
    );
  }

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
                builder: (_) => DetailsScreen(postId: comment.id),
              ),
            ),
          );
        },
      );
    } else {
      return Container();
    }
  }

  Widget _commentInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        PostForm(postId: postId),
        BlocBuilder<PostInputBloc, PostInputState>(
          builder: (context, state) => FlatButton(
            child: Text("Comment"),
            onPressed:
                !state.isValid ? null : () => _submitComment(context, state),
          ),
        )
      ],
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
