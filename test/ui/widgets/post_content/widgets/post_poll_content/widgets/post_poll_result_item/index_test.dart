import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/widgets/post_content/widgets/post_poll_content/widgets/export.dart';

import '../../../../../../../mocks/mocks.dart';
import '../../../../../../helper.dart';

void main() {
  testWidgets('PostPollResultItem: Displays export correctly',
      (WidgetTester tester) async {
    var option = PollOption(id: 1, text: 'apples');
    var optionTwo = PollOption(id: 0, text: 'apples');
    var userAccount = MooncakeAccount(
      profilePicUri: 'https://example.com/avatar.png',
      moniker: 'john-doe',
      cosmosAccount: cosmosAccount,
    );

    var poll = PostPoll(
      allowsAnswerEdits: false,
      question: 'favorite snack',
      endDate: '',
      allowsMultipleAnswers: false,
      options: [option, optionTwo],
      userAnswers: [
        PollAnswer(answer: 0, user: userAccount),
        PollAnswer(answer: 1, user: userAccount),
      ],
    );
    await tester.pumpWidget(
      makeTestableWidget(
        child: PostPollResultItem(
          index: 1,
          poll: poll,
          option: option,
          votedOption: true,
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(FractionallySizedBox), findsWidgets);
    expect(find.byType(RichText), findsWidgets);
  });
}
