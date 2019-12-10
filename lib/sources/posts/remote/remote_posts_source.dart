import 'dart:async';

import 'package:dwitter/entities/entities.dart';
import 'package:dwitter/repositories/repositories.dart';
import 'package:dwitter/sources/sources.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

/// Source that is responsible for handling the communication with the
/// blockchain, allowing to read incoming posts and send new ones.
class RemotePostsSource implements PostsSource {
  // Helpers
  final ChainHelper _chainHelper;
  final ChainEventHelper _chainEventHelper;

  final WalletSource _walletSource;

  // Streams
  final _postsStream = StreamController<Post>();
  StreamSubscription _subscription; // ignore: cancel_subscriptions

  // Converters
  final _msgConverter = MsgConverter();
  final _postConverter = RemotePostConverter();

  /// Public constructor
  RemotePostsSource({
    @required ChainEventHelper chainEventHelper,
    @required ChainHelper chainHelper,
    @required WalletSource walletSource,
  })  : assert(walletSource != null),
        _walletSource = walletSource,
        assert(chainEventHelper != null),
        _chainEventHelper = chainEventHelper,
        assert(chainHelper != null),
        _chainHelper = chainHelper;

  /// Observes the chain events
  StreamSubscription<List<ChainEvent>> _observeEvents() {
    return _chainEventHelper.initObserve().listen((events) async {
      events.forEach((event) {
        if (event is PostCreatedEvent) {
          _handlePostCreatedEvent(event);
        } else if (event is PostLikedEvent) {
          _handlePostLikedEvent(event);
        } else if (event is PostUnlikedEvent) {
          _handlePostUnLikedEvent(event);
        }
      });
    });
  }

  /// Handles the messages telling that a new post has been created.
  void _handlePostCreatedEvent(PostCreatedEvent event) async {
    final post = await getPostById(event.postId);

    // Emit the updated parent
    if (post.hasParent) {
      final parent = await getPostById(post.parentId);
      _postsStream.add(parent);
    }

    // Emit the updated post
    _postsStream.add(post);
  }

  void _handlePostLikedEvent(PostLikedEvent event) async {
    final post = await getPostById(event.postId);
    _postsStream.add(post);
  }

  void _handlePostUnLikedEvent(PostUnlikedEvent event) async {
    final post = await getPostById(event.postId);
    _postsStream.add(post);
  }

  @override
  Stream<Post> get postsStream {
    if (_subscription == null) {
      print("Initializing remote source posts stream");
      _subscription = _observeEvents();
    }
    return _postsStream.stream;
  }

  @override
  Future<Post> getPostById(String postId) async {
    try {
      final data = await _chainHelper.queryChain("/posts/$postId");
      final post = _postConverter.toPost(PostJson.fromJson(data.result));
      return post;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<List<Post>> getPosts() {
    // TODO: implement getPosts
    throw UnimplementedError();
  }

  @override
  Future<List<Post>> getPostComments(String postId) {
    // TODO: implement getPostComments
    throw UnimplementedError();
  }

  @override
  Future<void> savePost(Post post) async {
    final wallet = await _walletSource.getWallet();
    final msg = _msgConverter.toMsgCreatePost(post);
    return _chainHelper.sendTx([msg], wallet);
  }

  @override
  Future<void> savePosts(List<Post> posts) async {
    final wallet = await _walletSource.getWallet();

    // Get the existing posts list
    final List<Post> existingPosts =
        await Future.wait(posts.map((p) => getPostById(p.id)));

    // Convert the posts into messages
    final messages = _msgConverter.convertPostsToMsg(
      posts: posts,
      existingPosts: existingPosts,
      wallet: wallet,
    );

    // Get the result of the transactions
    await _chainHelper.sendTx(messages, wallet);
  }

  @override
  Future<void> deletePost(String postId) {
    throw UnimplementedError("Cannot delete a remote post");
  }
}
