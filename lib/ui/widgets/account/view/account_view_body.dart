import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';

import 'account_cover_image_viewer.dart';
import 'account_avatar.dart';
import 'account_posts_viewer.dart';
import 'account_info_viewer.dart';
import 'account_options_button.dart';

/// Represents the body of the screen that is used by the user to view an
/// account details.
class AccountViewBody extends StatefulWidget {
  static const double COVER_HEIGHT = 160;
  static const double PICTURE_RADIUS = 40;
  static const double PADDING = 16;

  final User user;

  const AccountViewBody({
    Key key,
    @required this.user,
  }) : super(key: key);

  @override
  _AccountViewBodyState createState() => _AccountViewBodyState();
}

class _AccountViewBodyState extends State<AccountViewBody> {
  final _indicator = new GlobalKey<RefreshIndicatorState>();
  Completer<void> _refreshCompleter;

  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  PostsListBloc _postsListBloc;

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();

    _scrollController.addListener(_onScroll);
    _postsListBloc = BlocProvider.of<PostsListBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Cover
        Stack(
          children: [
            AccountCoverImageViewer(
              height: AccountViewBody.COVER_HEIGHT,
              coverImage: widget.user.coverPicUri,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [],
            )
          ],
        ),

        // Body
        RefreshIndicator(
          key: _indicator,
          onRefresh: () {
            _refreshData(context);
            return _refreshCompleter.future;
          },
          child: BlocBuilder<PostsListBloc, PostsListState>(
            builder: (context, postsState) {
              // Hide the refresh indicator
              final state = postsState;
              if (state is PostsLoaded && !state.refreshing) {
                _refreshCompleter?.complete();
                _refreshCompleter = Completer();
              }

              return ListView(
                padding: EdgeInsets.only(
                  top: AccountViewBody.COVER_HEIGHT -
                      AccountViewBody.PICTURE_RADIUS,
                ),
                controller: _scrollController,
                children: [
                  Stack(
                    children: [
                      _mainBody(context),
                      _profileImage(),

                      BlocBuilder<AccountBloc, AccountState>(
                        builder: (context, state) {
                          final account = (state as LoggedIn).user;
                          if (widget.user.address == account.address) {
                            return Positioned(
                              top: 8,
                              right: AccountViewBody.PADDING,
                              child: AccountOptionsButton(),
                            );
                          }

                          return Container();
                        },
                      ),
                    ],
                  )
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  /// Returns a widget that allows to properly show the user profile image.
  Widget _profileImage() {
    return Positioned(
      left: AccountViewBody.PADDING,
      child: AccountAvatar(
        size: AccountViewBody.PICTURE_RADIUS * 2,
        border: AccountViewBody.PICTURE_RADIUS / 10,
        user: widget.user,
      ),
    );
  }

  /// Returns the main body of the screen, containing everything except the
  /// profile and cover images.
  Widget _mainBody(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: AccountViewBody.PICTURE_RADIUS),
      padding: EdgeInsets.only(top: AccountViewBody.PICTURE_RADIUS),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // User info
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AccountViewBody.PADDING),
            child: Column(
              children: [
                AccountInfoViewer(user: widget.user),
                if (widget.user.bio != null)
                  AccountBiographyViewer(user: widget.user),
              ],
            ),
          ),

          // Separator
          const SizedBox(height: 16),
          Container(height: 0.5, width: 400, color: Colors.grey[500]),
          const SizedBox(height: 16),

          // Posts list
          Flexible(child: AccountPostsViewer(user: widget.user)),
        ],
      ),
    );
  }

  /// When called, refreshes the user data.
  void _refreshData(BuildContext context) {
    BlocProvider.of<AccountBloc>(context).add(RefreshAccount());
    BlocProvider.of<PostsListBloc>(context).add(RefreshPosts());
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      _postsListBloc.add(FetchPosts());
    }
  }
}
