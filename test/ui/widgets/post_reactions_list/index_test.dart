import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:mooncake/entities/entities.dart';
import '../../../mocks/mocks.dart';
import '../../helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';

void main() {
  testWidgets('PostReactionsList: Displays export correctly',
      (WidgetTester tester) async {
    var userAccount = MooncakeAccount(
      profilePicUri: 'https://example.com/avatar.png',
      moniker: 'john-doe',
      cosmosAccount: cosmosAccount,
    );
    var reactionTest = <Reaction>[
      Reaction(user: userAccount, value: 'laugh', code: '123'),
      Reaction(user: userAccount, value: 'laugh', code: '123'),
      Reaction(user: userAccount, value: 'laugh', code: '123'),
      Reaction(user: userAccount, value: 'laugh', code: '123'),
      Reaction(user: userAccount, value: 'laugh', code: '123'),
      Reaction(user: userAccount, value: 'laugh', code: '123'),
      Reaction(user: userAccount, value: 'laugh', code: '123'),
      Reaction(user: userAccount, value: 'laugh', code: '123'),
    ];
    var mockAccountBloc = MockAccountBloc();
    when(mockAccountBloc.state)
        .thenReturn(LoggedIn.initial(userAccount, [userAccount]));
    await tester.pumpWidget(makeTestableWidget(
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AccountBloc>(
            create: (_) => mockAccountBloc,
          ),
        ],
        child:
            PostReactionsList(post: testPost.copyWith(reactions: reactionTest)),
      ),
    ));

    await tester.pumpAndSettle();

    expect(find.byIcon(MooncakeIcons.more), findsNothing);
    expect(find.byType(Wrap), findsOneWidget);
    expect(find.byType(PostReactionAction), findsWidgets);
    expect(find.byType(ActionChip), findsWidgets);
  });
}
