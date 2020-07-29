import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/ui/ui.dart';
import 'widgets/export.dart';

/// Represents the list of all the reactions added to a post.
class PostDetailsReactionsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostDetailsBloc, PostDetailsState>(
      builder: (BuildContext context, PostDetailsState state) {
        if (state is LoadingPostDetails) {
          return Container();
        }

        final currentState = state as PostDetailsLoaded;
        return Container(
          padding: EdgeInsets.only(
            top: NestedScrollView.sliverOverlapAbsorberHandleFor(context)
                .layoutExtent,
          ),
          child: currentState.reactionsCount == 0
              ? _emptyReactionsContainer(context)
              : _reactionsList(context, currentState),
        );
      },
    );
  }

  Widget _emptyReactionsContainer(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(child: Center()),
          Expanded(
            child: Center(
              child: Image.asset("assets/images/smile.png"),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                PostsLocalizations.of(context).translate("noReactionsYet"),
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _reactionsList(BuildContext context, PostDetailsLoaded state) {
    return CustomScrollView(
      shrinkWrap: true,
      key: PageStorageKey<String>("reactions"),
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return PostReactionItem(
                reaction: state.reactions[index],
              );
            },
            childCount: state.reactions.length,
          ),
        )
      ],
    );
  }
}
