import 'package:flutter/widgets.dart';

class PostsKeys {
  static final navigatorKey = GlobalKey<NavigatorState>();

  // --- Login ---
  static final loginScreenLogo = const Key('__loginScreenLogo__');

  static final tabs = const Key('__tabs__');
  static final allPostsTab = const Key('__allPostsTab__');
  static final accountTab = const Key('__accountTab__');

  static final postsList = const Key('__postsList__');
  static final postsLoading = const Key('__postsLoading__');
  static final postsEmptyContainer = const Key('__postsEmptyContainer__');

  // --- Post item ---
  static Key postItem(String id) {
    return Key('__postItem_$id\__');
  }

  static Key postItemHeader(String id) {
    return Key('__postItemHeader_$id\__');
  }

  static Key postItemMessage(String id) {
    return Key('__postItemMessage_$id\__');
  }

  static Key postItemImagePreviewer(String id) {
    return Key('__postItemMImagePreviewer_$id\__');
  }

  static Key postItemOwnerAvatar(String id) {
    return Key('__postItemOwnerAvatar_$id\__');
  }

  static Key postActionsBar(String id) {
    return Key('__postActionsBar$id\__');
  }

  static Key postsReactionBar(String id) {
    return Key('__postReactionsBar$id\__');
  }

  static Key postDetailsScreen(String id) {
    return Key('__postDetailsScreen$id\__');
  }

  // Post details
  static Key postDetails = const Key('__postDetails__');
  static Key postDetailsMessage = const Key('__postDetailsMessage__');
  static Key postDetailsHeader = const Key('__postDetailsHeader__');
  static Key postDetailsOwner = const Key('__postDetailsOwner__');
  static Key postDetailsOwnerAddress = const Key('__postDetailsOwnerAddress');

  // Comments
  static Key postCommentItem(String id) {
    return Key('__postCommentItem$id\___');
  }

  static Key postEditScreen = const Key('__postEditScreen__');
  static Key postMessageField = const Key('__postEditScreenMessageField__');

  static Key postItemPopup = const Key('__postItemPopup__');
}
