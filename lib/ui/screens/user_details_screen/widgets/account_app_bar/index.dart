import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';
import 'widgets/export.dart';

class AccountAppBar extends StatelessWidget {
  final User user;

  final bool isMyProfile;
  final bool isFollower;

  const AccountAppBar({
    Key key,
    @required this.user,
    @required this.isMyProfile,
    @required this.isFollower,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Widget leadingIcon = isMyProfile ? MenuButton() : null;
    return SliverAppBar(
      forceElevated: false,
      expandedHeight: 200,
      elevation: 0,
      stretch: true,
      pinned: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      leading: leadingIcon,
      actions: <Widget>[
        // future mile stone with draft posts feature
        // if (isMyProfile) DraftButton(),
        if (isMyProfile) AccountOptionsButton(),
      ],
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: <StretchMode>[
          StretchMode.zoomBackground,
          StretchMode.blurBackground
        ],
        background: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            SizedBox.expand(
              child: Container(
                padding: EdgeInsets.only(top: 50),
                height: 30,
                color: Theme.of(context).colorScheme.surface,
              ),
            ),
            // Container(height: 50, color: Colors.black),
            /// Cover image
            Container(
              height: 170,
              child: AccountCoverImageViewer(coverImage: user.coverPicUri),
            ),

            /// User avatar, message icon, profile edit and follow/following button
            Container(
              alignment: Alignment.bottomLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  /// User avatar
                  AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).colorScheme.surface,
                        width: 5,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: AccountAvatar(user: user, size: 80),
                  ),

                  /// Wallet button
                  Container(
                    margin: EdgeInsets.only(top: 175, right: 10),
                    child: Row(
                      children: [
                        if (isMyProfile)
                          PrimaryButton(
                            borderRadius: 60,
                            expanded: false,
                            onPressed: () {
                              BlocProvider.of<NavigatorBloc>(context)
                                  .add(NavigateToWallet());
                            },
                            child: Text(
                              PostsLocalizations.of(context)
                                  .translate(Messages.walletButtonTooltip),
                            ),
                          ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
