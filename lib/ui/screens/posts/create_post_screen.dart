import 'package:mooncake/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Represents the callback that is used to return the data of the created
/// post.
typedef OnSaveCallback = Function(
  String parentId,
  String message,
  bool allowsComments,
);

/// Screen that is shown to the user in order to allow him to input the
/// message of a new post.
/// When creating this screen, the [callback] parameter should be given. It
/// represents the method that must be called upon the click on the save button
/// inside the editor itself.
class CreatePostScreen extends StatelessWidget {
  final OnSaveCallback callback;

  const CreatePostScreen({
    Key key,
    @required this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostInputBloc.create(),
      child: BlocBuilder<PostInputBloc, PostInputState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(PostsLocalizations.of(context).createPost),
            ),
            body: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: PostForm(
                      hint: PostsLocalizations.of(context).newPostHint,
                      expanded: true,
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Checkbox(
                        value: state.allowsComments,
                        onChanged: (value) {
                          final bloc = BlocProvider.of<PostInputBloc>(context);
                          bloc.add(AllowsCommentsChanged(value));
                        },
                      ),
                      Text("Allows comments"),
                    ],
                  ),
                  if (!state.saving)
                    _createPostButton(context, state)
                  else
                    _savingLoadingBar(context)
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _createPostButton(BuildContext context, PostInputState state) {
    return Row(
      children: <Widget>[
        Expanded(
          child: RaisedButton(
            key: PostsKeys.saveNewPost,
            child: Text(PostsLocalizations.of(context).createPost),
            onPressed:
                !state.isValid ? null : () => _createPost(context, state),
          ),
        ),
      ],
    );
  }

  void _createPost(BuildContext context, PostInputState state) {
    // ignore: close_sinks
    final bloc = BlocProvider.of<PostInputBloc>(context);
    bloc.add(SavePost());
    callback(null, state.message, state.allowsComments);
    Navigator.pop(context);
  }

  Widget _savingLoadingBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
        const SizedBox(
            height: 16,
            width: 16,
            child: const LoadingIndicator(),
          ),
        const SizedBox(width: 16),
          Text(PostsLocalizations.of(context).savingPost)
        ],
      ),
    );
  }
}
