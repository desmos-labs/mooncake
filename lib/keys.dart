import 'package:flutter/widgets.dart';

class PostsKeys {
  static final statsLoadingIndicator = const Key('__statsLoadingIndicator__');
  static final emptyStatsContainer = const Key('__emptyStatsContainer__');
  static final emptyDetailsContainer = const Key('__emptyDetailsContainer__');

  static final addPost = const Key('__addPost__');
  static final tabs = const Key('__tabs__');
  static final postsTab = const Key('__postsTab__');
  static final statsTab = const Key('__statsTab__');

  static final postsList = const Key('__postsList__');
  static final postsLoading = const Key('__postsLoading__');
  static final postsEmptyContainer = const Key('__postsEmptyContainer__');

  static Key postItem(String id) => Key('__postItem_$id\__');
  static Key postItemMessage(String id) => Key('__postItemMessage_$id\__');
  static Key postItemOwner(String id) => Key('__postItemOwner_$id\__');
  static Key postItemOwnerAvatar(String id) =>
      Key('__postItemOwnerAvatar_$id\__');
  static Key postActionsBar(String id) => Key('__postActionsBar$id\__');

  static Key postDetailsScreen = const Key('__postDetailsScreen__');
  static Key postDetails = const Key('__postDetails__');
  static Key postDetailsMessage = const Key('__postDetailsMessage__');
  static Key postDetailsHeader = const Key('__postDetailsHeader__');
  static Key postDetailsOwner = const Key('__postDetailsOwner__');
  static Key postDetailsOwnerAddress = const Key('__postDetailsOwnerAddress');
}
