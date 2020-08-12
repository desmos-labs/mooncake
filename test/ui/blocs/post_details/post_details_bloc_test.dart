import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/usecases/usecases.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:mooncake/entities/entities.dart';
import '../../../mocks/mocks.dart';

class MockGetPostDetailsUseCase extends Mock implements GetPostDetailsUseCase {}

class MockGetCommentsUseCase extends Mock implements GetCommentsUseCase {}

void main() {
  MockGetPostDetailsUseCase mockGetPostDetailsUseCase;
  MockGetCommentsUseCase mockGetCommentsUseCase;
  setUp(() {
    mockGetPostDetailsUseCase = MockGetPostDetailsUseCase();
    mockGetCommentsUseCase = MockGetCommentsUseCase();
  });

  group(
    'PostDetailsBloc',
    () {
      PostDetailsBloc postDetailsBloc;
      String postId = '123';
      MooncakeAccount userAccount = MooncakeAccount(
        profilePicUri: "https://example.com/avatar.png",
        moniker: "john-doe",
        cosmosAccount: CosmosAccount(
          accountNumber: 153,
          address: "desmos1ew60ztvqxlf5kjjyyzxf7hummlwdadgesu3725",
          coins: [
            StdCoin(amount: "10000", denom: "udaric"),
          ],
          sequence: 45,
        ),
      );
      setUp(
        () {
          final postController = StreamController<Post>();
          when(mockGetPostDetailsUseCase.stream(postId))
              .thenAnswer((_) => postController.stream);
          final commentsController = StreamController<List<Post>>();
          when(mockGetCommentsUseCase.stream(postId))
              .thenAnswer((_) => commentsController.stream);
          when(mockGetPostDetailsUseCase.fromRemote(any))
              .thenAnswer((_) => Future.value(testPost));
          when(mockGetCommentsUseCase.fromRemote(any))
              .thenAnswer((_) => Future.value(testPosts));

          postDetailsBloc = PostDetailsBloc(
            user: userAccount,
            postId: postId,
            getPostDetailsUseCase: mockGetPostDetailsUseCase,
            getCommentsUseCase: mockGetCommentsUseCase,
          );
        },
      );

      blocTest(
        'ShowTab: work properly',
        build: () async {
          return postDetailsBloc;
        },
        act: (bloc) async {
          bloc.add(ShowTab(PostDetailsTab.REACTIONS));
          bloc.add(ShowTab(PostDetailsTab.COMMENTS));
        },
        expect: [
          PostDetailsLoaded.first(
            user: userAccount,
            post: testPost,
            comments: testPosts,
          ),
          PostDetailsLoaded(
            refreshing: false,
            user: userAccount,
            post: testPost,
            comments: testPosts,
            selectedTab: PostDetailsTab.REACTIONS,
          ),
          PostDetailsLoaded(
            refreshing: false,
            user: userAccount,
            post: testPost,
            comments: testPosts,
            selectedTab: PostDetailsTab.COMMENTS,
          ),
        ],
      );
    },
  );
}
