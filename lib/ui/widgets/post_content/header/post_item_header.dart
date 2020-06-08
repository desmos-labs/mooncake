import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/theme/theme.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:timeago/timeago.dart' as timeago;

/// Contains the info that are shown on top of a [PostListItem]. The following
/// data are :
/// - the owner o the post
/// - the block height at which the post has been created
class PostItemHeader extends StatelessWidget {
  final Post post;

  const PostItemHeader({
    @required this.post,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, state) {
        final account = (state as LoggedIn).user;
        return Row(
          children: <Widget>[
            Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(1000),
                onTap: () => _onTapUser(context),
                child: Row(
                  children: [
                    // User picture
                    AccountAvatar(size: 40, user: post.owner),

                    // Spacer
                    const SizedBox(width: ThemeSpaces.smallGutter),

                    // Username and time ago
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            post.owner.screenName,
                            overflow: TextOverflow.ellipsis,
                            style:
                                Theme.of(context).textTheme.subtitle1.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                          ),
                          Text(
                            timeago.format(post.dateTime.toLocal()),
                            style: Theme.of(context).textTheme.caption,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (post.owner.address != account.cosmosAccount.address)
              _moreActionButton(context)
          ],
        );
      },
    );
  }

  Widget _moreActionButton(BuildContext context) {
    final size = 16.0;
    return Row(
      children: <Widget>[
        SizedBox(width: 16),
        SizedBox(
          width: size,
          height: size,
          child: IconButton(
            alignment: Alignment.center,
            padding: EdgeInsets.zero,
            icon: Icon(MooncakeIcons.more, size: size),
            onPressed: () => _showPostOptions(context),
          ),
        ),
      ],
    );
  }

  void _showPostOptions(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return GenericPopup(
          onTap: () => Navigator.pop(context),
          padding: EdgeInsets.all(4),
          content: PostOptionsPopup(post: post),
        );
      },
    );
  }

  void _onTapUser(BuildContext context) {
    BlocProvider.of<NavigatorBloc>(context)
        .add(NavigateToUserDetails(post.owner));
  }
}
