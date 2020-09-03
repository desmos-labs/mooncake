import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:mooncake/ui/widgets/posts_list_item/widgets/post_actions_bar/widgets/export.dart';

import '../../../../../../../mocks/mocks.dart';
import '../../../../../../../mocks/posts.dart';
import '../../../../../../helper.dart';

void main() {
  testWidgets('PostLikesCounter: Displays export correctly',
      (WidgetTester tester) async {
    var userAccount = MooncakeAccount(
      profilePicUri: 'https://example.com/avatar.png',
      moniker: 'john-doe',
      cosmosAccount: cosmosAccount,
    );
    var reactionTest = <Reaction>[
      Reaction(user: userAccount, value: Constants.LIKE_REACTION, code: '123'),
    ];
    StateSetter setStateController;

    await tester.pumpWidget(
      makeTestableWidget(
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            setStateController = setState;

            return PostLikesCounter(
              post: testPost.copyWith(reactions: reactionTest),
            );
          },
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byType(AccountAvatar), findsOneWidget);

    setStateController(() {
      reactionTest.add(
        Reaction(
            user: userAccount, value: Constants.LIKE_REACTION, code: '123'),
      );
    });
    await tester.pumpAndSettle();
    expect(find.byType(AccountAvatar), findsNWidgets(2));

    setStateController(() {
      reactionTest.add(
        Reaction(
            user: userAccount, value: Constants.LIKE_REACTION, code: '123'),
      );
    });
    await tester.pumpAndSettle();
    expect(find.byType(AccountAvatar), findsNWidgets(3));

    setStateController(() {
      reactionTest.add(Reaction(
        user: userAccount,
        value: Constants.LIKE_REACTION,
        code: '123',
      ));
      reactionTest.add(Reaction(
        user: userAccount,
        value: Constants.LIKE_REACTION,
        code: '123',
      ));
      reactionTest.add(Reaction(
        user: userAccount,
        value: Constants.LIKE_REACTION,
        code: '123',
      ));
      reactionTest.add(Reaction(
        user: userAccount,
        value: Constants.LIKE_REACTION,
        code: '123',
      ));
    });
    await tester.pumpAndSettle();
    expect(find.byType(AccountAvatar), findsNWidgets(6));
    expect(find.text('...'), findsOneWidget);
  });
}
