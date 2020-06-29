import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/ui/ui.dart';

/// Represents the [AppBar] that is going to be shown to the user when
/// he visualizes the posts screen.
AppBar postsAppBar(BuildContext context) {
  return AppBar(
    centerTitle: true,
    title: Text(PostsLocalizations.of(context).appName),
    backgroundColor: Colors.transparent,
    actions: [
      if (kDebugMode)
        IconButton(
          icon: Icon(MooncakeIcons.delete),
          onPressed: () {
            BlocProvider.of<PostsListBloc>(context).add(DeletePosts());
          },
        ),
    ],
  );
}
