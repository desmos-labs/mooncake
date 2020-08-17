import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'widgets/export.dart';

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
              child: Row(
                children: [
                  // User picture
                  InkWell(
                    borderRadius: BorderRadius.circular(1000),
                    onTap: () => _onTapUser(context),
                    child: AccountAvatar(size: 40, user: post.owner),
                  ),

                  // Spacer
                  const SizedBox(width: ThemeSpaces.largeGutter),

                  // Username and time ago
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          post.owner.screenName,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.subtitle1.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                        Text(
                          timeago.format(
                            post.dateTime.add(DateTime.now().timeZoneOffset),
                            clock: DateTime.now(),
                          ),
                          style: Theme.of(context).textTheme.caption.copyWith(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.onSecondary),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (post.owner.address != account.cosmosAccount.address)
              PostMoreButton(post: post),
          ],
        );
      },
    );
  }

  void _onTapUser(BuildContext context) {
    BlocProvider.of<NavigatorBloc>(context)
        .add(NavigateToUserDetails(post.owner));
  }
}
