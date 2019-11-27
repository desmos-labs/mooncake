import 'package:desmosdemo/blocs/blocs.dart';
import 'package:desmosdemo/dependency_injection/export.dart';
import 'package:desmosdemo/keys.dart';
import 'package:desmosdemo/models/models.dart';
import 'package:desmosdemo/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../localization.dart';

/// Represents the screen that is shown to the user when he wants
/// to visualize the details of a specific [post].
class DetailsScreen extends StatelessWidget {
  final Post post;

  DetailsScreen(this.post) : super(key: PostsKeys.postDetailsScreen(post.id));

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PostCommentsBloc>(
          builder: (_) => PostCommentsBloc(repository: Injector.get())
            ..add(LoadPostComments(post.id)),
        ),
        BlocProvider<PostsBloc>(
          builder: (_) => BlocProvider.of<PostsBloc>(context),
        )
      ],
      child: BlocBuilder<PostCommentsBloc, PostCommentsState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(FlutterBlocLocalizations.of(context).post),
            ),
            body: post == null
                ? Container(key: PostsKeys.emptyDetailsContainer)
                : _body(state, BlocProvider.of(context)),
          );
        },
      ),
    );
  }

  Widget _body(PostCommentsState state, PostsBloc bloc) {
    return Padding(
      padding: EdgeInsets.all(0),
      child: Column(
        children: <Widget>[
          Flexible(
            child: ListView(
              children: <Widget>[
                _postHeader(),
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: PostActionsBar(
                    post: post,
                    onLikedChanged: (liked) {
                      if (liked) {
                        bloc.add(UnlikePost(post));
                      } else {
                        bloc.add(LikePost(post));
                      }
                    },
                  ),
                ),
                const Divider(height: 1),
                _comments(state),
              ],
            ),
          ),
          CommentForm(post: post),
        ],
      ),
    );
  }

  Widget _postHeader() => PostDetails(
        key: PostsKeys.postDetails,
        post: post,
      );

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
            post: comment,
            onTap: () async => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => DetailsScreen(comment)),
            ),
          );
        },
      );
    } else {
      return Container();
    }
  }
}
