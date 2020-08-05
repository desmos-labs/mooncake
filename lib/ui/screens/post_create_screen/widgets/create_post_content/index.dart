import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/screens/post_create_screen/blocs/export.dart';
import 'package:mooncake/ui/ui.dart';

import 'widgets/export.dart';

/// Contains the main content of the post creation screen.
/// Such content includes a top bar and the [TextFormField] inside which
/// the post message is inserted.
class CreatePostContent extends StatelessWidget {
  final Post parentPost;
  final double bottomPadding;

  const CreatePostContent({
    Key key,
    this.parentPost,
    @required this.bottomPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final padding = 8.0;
    return BlocBuilder<PostInputBloc, PostInputState>(
      builder: (context, state) {
        return SafeArea(
          child: Column(
            children: <Widget>[
              CreatePostTopBar(),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.only(
                    left: padding,
                    right: padding,
                    bottom: padding + bottomPadding,
                  ),
                  children: <Widget>[
                    if (parentPost != null) _parentPostPreview(context),
                    _postTextInput(context, state),
                    if (state.medias.isNotEmpty) _imagesPreview(),
                    if (state.poll != null) _pollCreator(),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _parentPostPreview(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(4.0),
      ),
      padding: EdgeInsets.all(16),
      child: PostContent(post: parentPost),
    );
  }

  Widget _postTextInput(BuildContext context, PostInputState state) {
    final border = UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.transparent),
    );
    final isValid = state.isValid;

    return TextFormField(
      maxLength: 500,
      textInputAction: TextInputAction.newline,
      minLines: null,
      maxLines: null,
      onFieldSubmitted: isValid ? (_) => _onSubmitted(context) : null,
      key: PostsKeys.postMessageField,
      autofocus: true,
      onChanged: (value) => _messageChanged(context, value),
      decoration: InputDecoration(
        hintText:
            PostsLocalizations.of(context).translate(Messages.createPostHint),
        border: border,
        focusedBorder: border,
        enabledBorder: border,
        disabledBorder: border,
        errorBorder: border,
        focusedErrorBorder: border,
      ),
    );
  }

  Widget _imagesPreview() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const SizedBox(height: 16),
        CreatePostImagesList(),
      ],
    );
  }

  void _messageChanged(BuildContext context, String value) {
    BlocProvider.of<PostInputBloc>(context).add(MessageChanged(value));
  }

  void _onSubmitted(BuildContext context) {
    BlocProvider.of<PostInputBloc>(context).add(SavePost());
  }

  Widget _pollCreator() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 16),
        PostPollCreator(),
      ],
    );
  }
}
