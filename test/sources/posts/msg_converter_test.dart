import 'package:flutter/cupertino.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/sources/posts/export.dart';

import '../../mocks/posts.dart';

class MockWallet extends Mock implements Wallet {
  @override
  String get bech32Address => "address";
}

void main() {
  final converter = MsgConverter();

  test('convertPostsToMsg', () {
    final wallet = MockWallet();

    final posts = [
      testPosts[0],
      testPosts[1].copyWith(
        reactions: testPosts[1].reactions +
            [Reaction(owner: wallet.bech32Address, value: "🤎")],
      ),
      testPosts[2],
    ];
    final remotePosts = [
      null,
      testPosts[1],
      testPosts[2].copyWith(
        reactions: testPosts[2].reactions +
            [Reaction(owner: wallet.bech32Address, value: "💗")],
      ),
    ];

    // The first post should be added
    // The second post has a reaction that should be added
    // The third post has a reaction that should be deleted
    final expected = [
      MsgCreatePost(
        parentId: "0",
        message: "Hello dreamers! ✨",
        allowsComments: true,
        subspace: "desmos",
        optionalData: null,
        creator: wallet.bech32Address,
        creationDate: "2020-01-21T13:16:10.123Z",
      ),
      MsgAddPostReaction(
        user: wallet.bech32Address,
        postId: testPosts[1].id,
        reaction: "🤎",
      ),
      MsgRemovePostReaction(
        reaction: "💗",
        user: wallet.bech32Address,
        postId: testPosts[2].id,
      ),
    ];

    final result = converter.convertPostsToMsg(
      posts: posts,
      existingPosts: remotePosts,
      wallet: wallet,
    );
    expect(result, expected);
  });
}
