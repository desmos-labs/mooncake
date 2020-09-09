import 'package:intl/intl.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/sources/sources.dart';
import 'package:test/test.dart';

import '../../../../mocks/mocks.dart';

void main() {
  final converter = PostsMsgConverter();

  /// Allows to crete a mock post having the given id.
  Post _createPost(String id) {
    return Post(
      id: id,
      message: id,
      created: DateFormat(Post.DATE_FORMAT).format(DateTime.now()),
      subspace: id,
      owner: User.fromAddress(id),
      status: PostStatus.storedLocally('address'),
    );
  }

  test('convertPostsToMsg', () {
    final wallet = MockWallet();

    final testPosts = [
      _createPost('1'),
      _createPost('2'),
      _createPost('3'),
    ];

    final posts = [
      testPosts[0],
      testPosts[1].copyWith(
        reactions: testPosts[1].reactions +
            [Reaction.fromValue('🤎', User.fromAddress(wallet.bech32Address))],
      ),
      testPosts[2],
    ];
    final remotePosts = [
      null,
      testPosts[1],
      testPosts[2].copyWith(
        reactions: testPosts[2].reactions +
            [Reaction.fromValue('💗', User.fromAddress(wallet.bech32Address))],
      ),
    ];

    // The first post should be added
    // The second post has a reaction that should be added
    // The third post has a reaction that should be deleted
    final expected = [
      MsgCreatePost(
        parentId: testPosts[0].parentId,
        message: testPosts[0].message,
        allowsComments: testPosts[0].allowsComments,
        subspace: testPosts[0].subspace,
        creator: wallet.bech32Address,
        optionalData: null, // Optional data should be null if empty
        medias: null, // Medias should be null if empty
        poll: null, // Poll should be null
      ),
      MsgAddPostReaction(
        user: wallet.bech32Address,
        postId: testPosts[1].id,
        reaction: '🤎',
      ),
      MsgRemovePostReaction(
        reaction: '💗',
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
