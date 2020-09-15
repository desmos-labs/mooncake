import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:mooncake/ui/widgets/post_content/widgets/export.dart';
import 'package:mooncake/ui/widgets/post_content/widgets/post_poll_content/widgets/export.dart';

import '../../../../../mocks/mocks.dart';
import '../../../../helper.dart';

void main() {
  testWidgets('PostPollContent: Displays export correctly',
      (WidgetTester tester) async {
    var userAccount = MooncakeAccount(
      profilePicUri: 'https://example.com/avatar.png',
      moniker: 'john-doe',
      cosmosAccount: cosmosAccount,
    );

    var option = PollOption(id: 1, text: 'apples');
    var optionTwo = PollOption(id: 0, text: 'apples');
    var poll = PostPoll(
      allowsAnswerEdits: false,
      question: 'favorite snack',
      endDate: '2020-05-01T21:00:00Z',
      allowsMultipleAnswers: false,
      options: [option, optionTwo],
      userAnswers: [
        PollAnswer(answer: 0, user: userAccount),
        PollAnswer(answer: 1, user: userAccount),
      ],
    );

    var formattedTestPoll = testPost.copyWith(poll: poll);

    var mockAccountBloc = MockAccountBloc();
    when(mockAccountBloc.state)
        .thenReturn(LoggedIn.initial(userAccount, [userAccount]));

    await tester.pumpWidget(
      makeTestableWidget(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<AccountBloc>(
              create: (_) => mockAccountBloc,
            ),
          ],
          child: PostPollContent(post: formattedTestPoll),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(PostPollResultItem), findsWidgets);
    expect(find.byType(PostPollOptionItem), findsNothing);
  });
}
