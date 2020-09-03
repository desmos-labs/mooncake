import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';

import '../../../mocks/mocks.dart';
import '../../../mocks/posts.dart';
import '../../helper.dart';

void main() {
  testWidgets('PostReactionAction: Displays export correctly',
      (WidgetTester tester) async {
    var mockAccountBloc = MockAccountBloc();
    var reactionValue = '';
    var reactionCode = '';
    var reactionCount = 5;

    var userAccount = MooncakeAccount(
      profilePicUri: 'https://example.com/avatar.png',
      moniker: 'john-doe',
      cosmosAccount: cosmosAccount,
    );

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
          child: PostReactionAction(
            post: testPost,
            reactionValue: reactionValue,
            reactionCode: reactionCode,
            reactionCount: reactionCount,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(ActionChip), findsOneWidget);
    expect(
      tester.widget<Text>(find.byType(Text).last).data,
      '5',
    );
  });
}
