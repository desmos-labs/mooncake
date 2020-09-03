import 'package:flutter/material.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';

class AccountNameRow extends StatelessWidget {
  final bool isMyProfile;
  final User user;

  const AccountNameRow({
    Key key,
    @required this.user,
    @required this.isMyProfile,
  }) : super(key: key);

  String getBio(String bio) {
    if (isMyProfile) {
      return bio ?? 'Edit your profile to add a bio';
    } else if (bio == null) {
      return 'No bio available';
    } else {
      return bio;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: Row(
            children: <Widget>[
              Text(
                user.screenName,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
              SizedBox(width: 3),
//              user.isVerified
//                  ? customIcon(context,
              //  icon: AppIcon.blueTick,
//                      istwitterIcon: true,
//                      iconColor: AppColor.primary,
//                      size: 13,
//                      paddingIcon: 3)
//                  : SizedBox(width: 0),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 9),
          child: Text(user.address, style: Theme.of(context).textTheme.caption),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Text(
            getBio(user.bio),
          ),
        ),

        /// Location
//        Padding(
//          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//          child: Row(
//            crossAxisAlignment: CrossAxisAlignment.start,
//            children: <Widget>[
//              customIcon(context,
//                  icon: AppIcon.locationPin,
//                  size: 14,
//                  istwitterIcon: true,
//                  paddingIcon: 5,
//                  iconColor: AppColor.darkGrey),
//              SizedBox(width: 10),
//              Expanded(
//                child: customText(
//                  user.location,
//                  style: TextStyle(color: AppColor.darkGrey),
//                ),
//              )
//            ],
//          ),
//        ),

        /// Join date
//        Padding(
//          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//          child: Row(
//            children: <Widget>[
//              customIcon(context,
//                  icon: AppIcon.calender,
//                  size: 14,
//                  istwitterIcon: true,
//                  paddingIcon: 5,
//                  iconColor: AppColor.darkGrey),
//              SizedBox(width: 10),
//              customText(
//                getJoiningDate(user.createdAt),
//                style: TextStyle(color: AppColor.darkGrey),
//              ),
//            ],
//          ),
//        ),

        /// Following/Followers
//        Container(
//          alignment: Alignment.center,
//          child: Row(
//            children: <Widget>[
//              SizedBox(
//                width: 10,
//                height: 30,
//              ),
//              _tappbleText(context, '${user.getFollower()}', ' Followers',
//                  'FollowerListPage'),
//              SizedBox(width: 40),
//              _tappbleText(context, '${user.getFollowing()}', ' Following',
//                  'FollowingListPage'),
//            ],
//          ),
//        ),
      ],
    );
  }
}
