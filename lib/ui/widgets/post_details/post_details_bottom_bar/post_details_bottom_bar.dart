import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/ui/ui.dart';

/// Represents the bottom bar that is shown inside the details of a post.
class PostDetailsBottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostDetailsBloc, PostDetailsState>(
      builder: (BuildContext context, PostDetailsState detailsState) {
        final state = detailsState as PostDetailsLoaded;
        return Container(
          width: MediaQuery.of(context).size.width,
          color: Theme.of(context).primaryColorDark,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                icon: Icon(MooncakeIcons.comment),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(
                  state.isLiked
                      ? MooncakeIcons.heartFilled
                      : MooncakeIcons.heart,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(MooncakeIcons.addReaction),
                onPressed: () {},
              )
            ],
          ),
        );
      },
    );
  }
}
