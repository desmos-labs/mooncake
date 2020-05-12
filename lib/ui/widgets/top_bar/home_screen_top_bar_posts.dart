import 'package:dynamic_theme/dynamic_theme.dart';
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
    leading: IconButton(
      icon: Icon(Theme.of(context).brightness == Brightness.light
          ? MooncakeIcons.lightbulb
          : MooncakeIcons.lightbulbF),
      tooltip: PostsLocalizations.of(context).brightnessButtonTooltip,
      onPressed: () {
        DynamicTheme.of(context).setBrightness(
            Theme.of(context).brightness == Brightness.dark
                ? Brightness.light
                : Brightness.dark);
      },
    ),
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
