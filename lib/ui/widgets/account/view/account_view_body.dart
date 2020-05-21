import 'package:flutter/material.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';

import 'account_cover_image_viewer.dart';
import 'account_profile_image_viewer.dart';
import 'account_posts_viewer.dart';

/// Represents the body of the screen that is used by the user to view an
/// account details.
class AccountViewBody extends StatelessWidget {
  static const double COVER_HEIGHT = 160;
  static const double PICTURE_RADIUS = 40;
  static const double PADDING = 16;

  final User user;

  const AccountViewBody({
    Key key,
    @required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            AccountCoverImageViewer(
              height: COVER_HEIGHT,
              coverImage: user.coverPicUrl,
            ),
          ],
        ),
        ListView(
          padding: EdgeInsets.only(top: COVER_HEIGHT - PICTURE_RADIUS),
          children: [
            Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(top: PICTURE_RADIUS),
                  padding: EdgeInsets.only(top: PICTURE_RADIUS),
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _userInfo(context),
                      if (user.bio != null) _biography(context),
                      const SizedBox(height: 16),
                      Container(height: 1, color: Colors.grey[500]),
                      const SizedBox(height: 8),
                      Flexible(child: AccountPostsViewer(user: user)),
                    ],
                  ),
                ),
                Positioned(
                  left: PADDING,
                  child: AccountProfileImageViewer(
                    radius: PICTURE_RADIUS,
                    border: PICTURE_RADIUS / 10,
                    profileImage: user.profilePicUrl,
                  ),
                ),
              ],
            )
          ],
        ),
      ],
    );
  }

  Widget _userInfo(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: PADDING),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text(
            user.screenName,
            style: Theme.of(context).textTheme.headline6.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            user.address,
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
    );
  }

  Widget _biography(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: PADDING),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Row(
            children: [
              SizedBox(
                height: 2,
                width: 80,
                child: Container(
                  color: Theme.of(context).primaryColorLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (user.bio != null) Text(user.bio),
        ],
      ),
    );
  }
}
