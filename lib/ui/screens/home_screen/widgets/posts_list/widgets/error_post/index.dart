import 'package:flutter/material.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/ui/ui.dart';

class ErrorPost extends StatelessWidget {
  final Post post;
  final bool lastChild;
  ErrorPost({@required this.post, this.lastChild = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: lastChild ? EdgeInsets.only(bottom: 10) : EdgeInsets.zero,
      color: Theme.of(context).colorScheme.secondaryVariant,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (post.images.isNotEmpty)
            Container(
                margin: EdgeInsets.only(right: 10),
                width: 40,
                height: 40,
                child: PostContentImage(media: post.images[0])),
          if (post.message?.isNotEmpty == true)
            Flexible(
              child: Text(
                post.message,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          if (post.message?.isEmpty == true && post.poll != null)
            Flexible(
              child: Text(
                post.poll.question ??
                    PostsLocalizations.of(context).translate(Messages.poll),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          Row(
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                iconSize: 20,
                icon: Icon(
                  MooncakeIcons.syncing,
                  color: Colors.white,
                ),
                onPressed: () {
                  _handleRetryPost(context);
                },
              ),
              IconButton(
                iconSize: 20,
                icon: Icon(MooncakeIcons.delete),
                color: Colors.white,
                onPressed: () {
                  _handleDeletePost(context);
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  void _handleRetryPost(BuildContext context) {
    BlocProvider.of<PostsListBloc>(context).add(RetryPostUpload(post));
  }

  void _handleDeletePost(BuildContext context) {
    BlocProvider.of<PostsListBloc>(context).add(DeletePost(post));
  }
}
