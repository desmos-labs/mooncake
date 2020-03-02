import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:mooncake/entities/entities.dart';

/// Represents a post like button that can be tapped to like a post if not
/// yet liked, or to remove a like if already liked.
class PostLikeAction extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    final bloc = PostLikeButtonBloc.create(context);

    return BlocBuilder(
      bloc: bloc,
      builder: (BuildContext context, PostLikeButtonState state) {
        final iconColor = Colors.red;
        IconData iconData = FontAwesomeIcons.heart;
        if (state.isLiked || state.isSelected) {
          iconData = FontAwesomeIcons.solidHeart;
        }

        final icon = Icon(iconData, color: iconColor);

        return Row(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                bloc.add(PostLikeButtonClicked());
              },
              onTapDown: (_) {
                bloc.add(PostLikeButtonSelectedStateChanged(true));
              },
              onTapUp: (_) {
                bloc.add(PostLikeButtonSelectedStateChanged(false));
              },
              onTapCancel: () {
                bloc.add(PostLikeButtonSelectedStateChanged(false));
              },
              child: SvgPicture.asset(
                state.isLiked || state.isSelected
                    ? "assets/icons/icon_like_pressed.png"
                    : "assets/icons/icon_like_default.png",
                color: iconColor,
              ),
            ),
            const SizedBox(width: 5.0),
            Text(
              state.likesCount.toStringOrEmpty(),
              style: Theme.of(context).textTheme.bodyText2.copyWith(
                    color: PostsTheme.textColorVeryLight,
                  ),
            ),
          ],
        );
      },
    );
  }
}
