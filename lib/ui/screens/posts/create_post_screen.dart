import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/ui/ui.dart';

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
                  if (state.medias?.isNotEmpty == true) _imagesPreview(state),
                  PostEditorActions(),
                  if (!state.saving)
                    CreatePostButton(callback: (post) {
                      callback(post);
                      Navigator.pop(context);
                    })
                  else
                    PostSavingProgressBar()
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  _imagesPreview(PostInputState state) {
    return Column(
      children: <Widget>[
        SizedBox(height: 16),
        PostImagesPreview(images: state.medias),
      ],
    );
  }
}
