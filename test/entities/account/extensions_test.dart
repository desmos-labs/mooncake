import 'package:flutter_test/flutter_test.dart';
import 'package:mooncake/entities/entities.dart';

void main() {
  final account = MooncakeAccount(
    cosmosAccount: CosmosAccount(
      sequence: 1,
      coins: [StdCoin(denom: "desmos", amount: "10000")],
      address: "desmos1y447pj22mtx5h8tu9m67qer28t7dvzrxc7mxwe",
      accountNumber: 10,
    ),
    name: "Harry E.",
    surname: "Ramsey",
    moniker: "harry_ramsey",
    bio: "Textile machine operator",
    profilePicUri: "shorturl.at/egy49",
    coverPicUri: "shorturl.at/hsxIK",
  );

  test('hasLiked works properly', () async {
    final post = Post(
      id: "1",
      message: "Test post",
      created: "2020-05-01T17:00:00Z",
      subspace: "mooncake",
      owner: User.fromAddress("address"),
    );
    expect(account.hasLiked(post), isFalse);

    final likedPost = post.copyWith(reactions: [
      Reaction(
        user: User.fromAddress(account.address),
        value: Constants.LIKE_REACTION,
      ),
    ]);
    expect(account.hasLiked(likedPost), isTrue);
  });

  test('hasVoted works properly', () {
    final poll = PostPoll(
      question: "Do you like Mooncake?",
      endDate: "2020-05-01T21:00:00.000Z",
      options: [
        PollOption(id: 1, text: "Yes"),
        PollOption(id: 2, text: "No"),
      ],
      isOpen: false,
      allowsMultipleAnswers: false,
      allowsAnswerEdits: false,
    );
    expect(account.hasVoted(poll), isFalse);

    final pollWithAnswer = poll.copyWith(
      userAnswers: [PollAnswer(user: account.toUser(), answer: 1)],
    );
    expect(account.hasVoted(pollWithAnswer), isTrue);
  });

  test('toUser works properly', () async {
    final expected = User(
      address: account.address,
      moniker: account.moniker,
      name: account.name,
      surname: account.surname,
      bio: account.bio,
      profilePicUri: account.profilePicUri,
      coverPicUri: account.coverPicUri,
    );
    expect(account.toUser(), equals(expected));
  });
}
