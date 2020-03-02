import 'package:flutter/widgets.dart';

class PostsKeys {
  static final navigatorKey = GlobalKey<NavigatorState>();

  static final statsLoadingIndicator = const Key('__statsLoadingIndicator__');
  static final emptyStatsContainer = const Key('__emptyStatsContainer__');
  static final emptyDetailsContainer = const Key('__emptyDetailsContainer__');

  static final addPost = const Key('__addPost__');
  static final tabs = const Key('__tabs__');
  static final allPostsTab = const Key('__allPostsTab__');
  static final likedPostsTab = const Key('__likedPostsTab__');
  static final notificationsTab = const Key('__notificationsTab__');
  static final yourPostsTab = const Key('__yourPostsTab__');

  static final postsList = const Key('__postsList__');
  static final postsLoading = const Key('__postsLoading__');
  static final postsEmptyContainer = const Key('__postsEmptyContainer__');

  // --- Post item ---
  static Key postItem(String id) => Key('__postItem_$id\__');
  static Key postItemHeader(String id) => Key('__postItemHeader_$id\__');
  static Key postItemMessage(String id) => Key('__postItemMessage_$id\__');
  static Key postItemImagePreviewer(String id) => Key('__postItemMImagePreviewer_$id\__');
  static Key postItemOwnerAvatar(String id) =>
      Key('__postItemOwnerAvatar_$id\__');
  static Key postActionsBar(String id) => Key('__postActionsBar$id\__');
  static Key postsReactionBar(String id) => Key('__postReactionsBar$id\__');

  static Key postDetailsScreen(String id) => Key('__postDetailsScreen$id\__');
  static Key postDetails = const Key('__postDetails__');
  static Key postDetailsMessage = const Key('__postDetailsMessage__');
  static Key postDetailsHeader = const Key('__postDetailsHeader__');
  static Key postDetailsOwner = const Key('__postDetailsOwner__');
  static Key postDetailsOwnerAddress = const Key('__postDetailsOwnerAddress');

  static Key postEditScreen = const Key('__postEditScreen__');
  static Key postMessageField = const Key('__postEditScreenMessageField__');
  static Key savePostFab = const Key('__savePostFab__');
  static Key saveNewPost = const Key('__saveNewPost__');

  static Key mnemonicField = const Key('__mnemonciField__');

  static Key syncErrorDialog = const Key('__syncingErrorDialog__');
}
