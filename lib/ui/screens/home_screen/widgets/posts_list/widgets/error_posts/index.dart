import 'package:flutter/material.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/ui/ui.dart';

class ErrorPost extends StatelessWidget {
  final Post post;

  ErrorPost({@required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.secondaryVariant,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              post.message,
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
                  // BlocProvider.of<PostsListBloc>(context).add(DeletePosts());
                },
              ),
              IconButton(
                iconSize: 20,
                icon: Icon(MooncakeIcons.delete),
                color: Colors.white,
                onPressed: () {
                  _handleDeletePost(context);
                  // BlocProvider.of<PostsListBloc>(context).add(DeletePosts());
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  _handleRetryPost(BuildContext context) {
    BlocProvider.of<PostsListBloc>(context).add(RetryPostUpload(post));
  }

  _handleDeletePost(BuildContext context) {
    BlocProvider.of<PostsListBloc>(context).add(RetryPostUpload(post));
  }
}
