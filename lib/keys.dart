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
  static Key postItemOwnerAvatar(String id) => Key('__postItemOwnerAvatar_$id\__');
  static Key postActionsBar(String id) => Key('__postActionsBar$id\__');

  static Key postDetailsScreen = const Key('__postDetailsScreen__');
  static Key detailsPostItemMessage = const Key('__detailsPostItemMessage__');
  static Key detailsPostItemOwner = const Key('__detailsPostItemOwner__');
}
