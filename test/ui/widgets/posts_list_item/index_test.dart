import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:mooncake/ui/widgets/posts_list_item/widgets/export.dart';

import '../../../mocks/mocks.dart';
import '../../../mocks/posts.dart';
import '../../helper.dart';

void main() {
  testWidgets('PostListItem: Displays export correctly',
      (WidgetTester tester) async {
    var mockAccountBloc = MockAccountBloc();
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
          child: PostListItem(post: testPost),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(PostContent), findsOneWidget);
    expect(find.byType(PostActionsBar), findsOneWidget);
    expect(find.byType(SizedBox), findsWidgets);
  });
}
