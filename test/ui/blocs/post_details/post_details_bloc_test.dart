import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:mooncake/usecases/usecases.dart';

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
      var postId = '123';
      var userAccount = MooncakeAccount(
        profilePicUri: 'https://example.com/avatar.png',
        moniker: 'john-doe',
        cosmosAccount: cosmosAccount,
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
        build: () {
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
