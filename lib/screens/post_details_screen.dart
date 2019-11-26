import 'package:desmosdemo/blocs/blocs.dart';
import 'package:desmosdemo/dependency_injection/export.dart';
import 'package:desmosdemo/keys.dart';
import 'package:desmosdemo/models/models.dart';
import 'package:desmosdemo/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../localization.dart';

/// Represents the screen that is shown to the user when he wants
/// to visualize the details of a specific [post].
class DetailsScreen extends StatelessWidget {
  final Post post;

  DetailsScreen({Key key, @required this.post})
      : super(key: key ?? PostsKeys.postDetailsScreen);

  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    final PostCommentsBloc bloc = PostCommentsBloc(
      repository: Injector.get(),
    )..add(LoadPostComments(post.id));

    return BlocBuilder<PostCommentsBloc, PostCommentsState>(
      bloc: bloc,
      builder: (context, state) {

        // Compute the proper length of items to be displayed
        // We start from 2 as we always have the header and the actions
        int itemsLength = 2;
        if (state is PostCommentsLoading) {
          itemsLength += 1;
        } else if (state is PostCommentsLoaded) {
          itemsLength += state.comments.length;
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(FlutterBlocLocalizations.of(context).post),
          ),
          body: post == null
              ? Container(key: PostsKeys.emptyDetailsContainer)
              : Padding(
                  padding: EdgeInsets.all(16.0),
                  child: ListView.separated(
                    itemCount: itemsLength,
                    separatorBuilder: (context, index) {
                      return const Divider(height: 16);
                    },
                    itemBuilder: (context, index) {
                      // Build the header
                      if (index == 0) {
                        return PostDetails(
                          key: PostsKeys.postDetails,
                          post: post,
                        );
                      }

                      // Build the actions
                      else if (index == 1) {
                        return PostActionsBar(post: post);
                      } else if (state is PostCommentsLoading) {
                        return LoadingIndicator();
                      } else if (state is PostCommentsLoaded) {
                        final comment = state.comments[index - 2];

                        // Build the comments
                        return PostItem(
                          post: comment,
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          onTap: () async => Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) {
                              return DetailsScreen(post: comment);
                            }),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
        );
      },
    );
  }
}
