import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';

import 'create_post_top_bar.dart';

import 'images/create_post_images_list.dart';

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
                    if (parentPost != null)
                      Card(
                        elevation: 0,
                        child: Container(
                          padding: EdgeInsets.all(16),
                          child: PostContent(post: parentPost),
                        ),
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                    TextFormField(
                      key: PostsKeys.postMessageField,
                      autofocus: true,
                      onChanged: (value) => _messageChanged(context, value),
                      decoration: InputDecoration(
                          hintText: "What's on your mind?",
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.transparent))),
                    ),
                    if (state.medias.isNotEmpty)
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const SizedBox(height: 10),
                          CreatePostImagesList(),
                        ],
                      ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  void _messageChanged(BuildContext context, String value) {
    BlocProvider.of<PostInputBloc>(context).add(MessageChanged(value));
  }
}
