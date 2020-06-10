import 'package:flutter/material.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/widgets/account/view/account_name_row.dart';

/// Represents the screen that allows to display the details of a given [user].
class UserDetailsScreen extends StatelessWidget {
  final User user;
  final bool isMyProfile;

  const UserDetailsScreen({
    Key key,
    @required this.user,
    @required this.isMyProfile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool isBoxScrolled) {
          return <Widget>[
            AccountAppBar(
              user: user,
              isMyProfile: isMyProfile,
              isFollower: false,
            ),
            SliverToBoxAdapter(
              child: Container(
                color: Theme.of(context).colorScheme.surface,
                child: AccountNameRow(
                  user: user,
                  isMyProfile: isMyProfile,
                ),
              ),
            ),
//            SliverList(
//              delegate: SliverChildListDelegate(
//                [
//                  Container(
//                    color: TwitterColor.white,
//                    child: TabBar(
//                      indicator: TabIndicator(),
//                      controller: _tabController,
//                      tabs: <Widget>[
//                        Text("Tweets"),
//                        Text("Tweets & replies"),
//                        Text("Media")
//                      ],
//                    ),
//                  )
//                ],
//              ),
//            )
          ];
        },
        body: AccountPostsViewer(user: user),
      ),
      bottomNavigationBar:
          isMyProfile ? SafeArea(child: TabSelector()) : SizedBox.shrink(),
    );
  }
}
