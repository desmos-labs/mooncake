import 'package:flutter_test/flutter_test.dart';
import 'package:mooncake/entities/entities.dart';

void main() {
  final account = MooncakeAccount(
    cosmosAccount: CosmosAccount(
      sequence: '1',
      coins: [StdCoin(denom: 'desmos', amount: '10000')],
      address: 'desmos1y447pj22mtx5h8tu9m67qer28t7dvzrxc7mxwe',
      accountNumber: '10',
    ),
    dtag: 'harry_ramsey',
    moniker: 'Harry E. Ramsey',
    bio: 'Textile machine operator',
    profilePicUri: 'shorturl.at/egy49',
    coverPicUri: 'shorturl.at/hsxIK',
  );

  test('hasLiked works properly', () async {
    final post = Post(
      id: '1',
      message: 'Test post',
      created: '2020-05-01T17:00:00Z',
      subspace: 'mooncake',
      owner: User.fromAddress('address'),
      status: PostStatus.storedLocally('address'),
    );
    expect(account.hasLiked(post), isFalse);

    final likedPost = post.copyWith(reactions: [
      Reaction.fromValue(
        Constants.LIKE_REACTION,
        User.fromAddress(account.address),
      ),
    ]);
    expect(account.hasLiked(likedPost), isTrue);
  });

  test('toUser works properly', () async {
    final expected = User(
      address: account.address,
      dtag: account.dtag,
      moniker: account.moniker,
      bio: account.bio,
      profilePicUri: account.profilePicUri,
      coverPicUri: account.coverPicUri,
    );
    expect(account.toUser(), equals(expected));
  });
}
