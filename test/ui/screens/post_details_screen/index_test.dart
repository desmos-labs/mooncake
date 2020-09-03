import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/screens/post_details_screen/widgets/export.dart';
import 'package:mooncake/ui/ui.dart';

import '../../../mocks/mocks.dart';
import '../../helper.dart';

void main() {
  var mockPostDetailsBloc = MockPostDetailsBloc();
  var mockAccountBloc = MockAccountBloc();
  var mockNavigatorBloc = MockNavigatorBloc();
  var userAccount = MooncakeAccount(
    profilePicUri: 'https://example.com/avatar.png',
    moniker: 'john-doe',
    cosmosAccount: cosmosAccount,
  );
  testWidgets('PostDetailsScreen: Displays correctly',
      (WidgetTester tester) async {
    when(mockPostDetailsBloc.state).thenReturn(PostDetailsLoaded.first(
      user: userAccount,
      post: testPost,
      comments: testPosts,
    ));

    when(mockAccountBloc.state)
        .thenReturn(LoggedIn.initial(userAccount, [userAccount]));

    await tester.pumpWidget(
      makeTestableWidget(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<PostDetailsBloc>(
              create: (_) => mockPostDetailsBloc,
            ),
            BlocProvider<AccountBloc>(
              create: (_) => mockAccountBloc,
            ),
            BlocProvider<NavigatorBloc>(
              create: (_) => mockNavigatorBloc,
            ),
          ],
          child: PostDetailsScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byType(PostDetailsMainContent), findsOneWidget);
  });

  testWidgets('PostDetailsScreen: Displays Loading correctly',
      (WidgetTester tester) async {
    when(mockPostDetailsBloc.state).thenReturn(LoadingPostDetails());

    await tester.pumpWidget(
      makeTestableWidget(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<PostDetailsBloc>(
              create: (_) => mockPostDetailsBloc,
            ),
            BlocProvider<AccountBloc>(
              create: (_) => mockAccountBloc,
            ),
            BlocProvider<NavigatorBloc>(
              create: (_) => mockNavigatorBloc,
            ),
          ],
          child: PostDetailsScreen(),
        ),
      ),
    );

    await tester.pump(const Duration(seconds: 5));
    expect(find.byType(PostDetailsMainContent), findsNothing);
    expect(find.byType(PostDetailsLoading), findsOneWidget);
  });
}
