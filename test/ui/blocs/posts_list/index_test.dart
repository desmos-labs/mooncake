import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:mooncake/usecases/usecases.dart';

import '../../../mocks/mocks.dart';

const syncPeriod = 30;

class MockAccountBloc extends Mock implements AccountBloc {}

class MockFirebaseAnalytics extends Mock implements FirebaseAnalytics {}

class MockGetHomePostsUseCase extends Mock implements GetHomePostsUseCase {}

class MockGetHomeEventsUseCase extends Mock implements GetHomeEventsUseCase {}

class MockSyncPostsUseCase extends Mock implements SyncPostsUseCase {}

class MockGetActiveAccountUseCase extends Mock
    implements GetActiveAccountUseCase {}

class MockGetNotificationsUseCase extends Mock
    implements GetNotificationsUseCase {}

class MockUpdatePostsStatusUseCase extends Mock
    implements UpdatePostsStatusUseCase {}

class MockManagePostReactionsUseCase extends Mock
    implements ManagePostReactionsUseCase {}

class MockHidePostUseCase extends Mock implements HidePostUseCase {}

class MockVotePollUseCase extends Mock implements VotePollUseCase {}

class MockDeletePostsUseCase extends Mock implements DeletePostsUseCase {}

class MockBlockUserUseCase extends Mock implements BlockUserUseCase {}

class MockUpdatePostUseCase extends Mock implements UpdatePostUseCase {}

class MockDeletePostUseCase extends Mock implements DeletePostUseCase {}

void main() {
  MockAccountBloc mockAccountBloc;
  MockFirebaseAnalytics mockFirebaseAnalytics;
  MockGetHomePostsUseCase mockGetHomePostsUseCase;
  MockGetHomeEventsUseCase mockGetHomeEventsUseCase;
  MockSyncPostsUseCase mockSyncPostsUseCase;
  MockGetNotificationsUseCase mockGetNotificationsUseCase;
  MockUpdatePostsStatusUseCase mockUpdatePostsStatusUseCase;
  MockManagePostReactionsUseCase mockManagePostReactionsUseCase;
  MockHidePostUseCase mockHidePostUseCase;
  MockVotePollUseCase mockVotePollUseCase;
  MockDeletePostsUseCase mockDeletePostsUseCase;
  MockBlockUserUseCase mockBlockUserUseCase;
  MockUpdatePostUseCase mockUpdatePostUseCase;
  MockDeletePostUseCase mockDeletePostUseCase;
  MockGetActiveAccountUseCase mockGetActiveAccountUseCase;

  setUp(() {
    mockAccountBloc = MockAccountBloc();
    mockFirebaseAnalytics = MockFirebaseAnalytics();
    mockGetHomePostsUseCase = MockGetHomePostsUseCase();
    mockGetHomeEventsUseCase = MockGetHomeEventsUseCase();
    mockSyncPostsUseCase = MockSyncPostsUseCase();
    mockGetNotificationsUseCase = MockGetNotificationsUseCase();
    mockUpdatePostsStatusUseCase = MockUpdatePostsStatusUseCase();
    mockManagePostReactionsUseCase = MockManagePostReactionsUseCase();
    mockHidePostUseCase = MockHidePostUseCase();
    mockVotePollUseCase = MockVotePollUseCase();
    mockDeletePostsUseCase = MockDeletePostsUseCase();
    mockBlockUserUseCase = MockBlockUserUseCase();
    mockUpdatePostUseCase = MockUpdatePostUseCase();
    mockDeletePostUseCase = MockDeletePostUseCase();
    mockGetActiveAccountUseCase = MockGetActiveAccountUseCase();
  });

  group(
    'PostsListBloc',
    () {
      PostsListBloc postsListBloc;
      // String postId = '123';
      var userAccount = MooncakeAccount(
        profilePicUri: 'https://example.com/avatar.png',
        moniker: 'john-doe',
        cosmosAccount: cosmosAccount,
      );
      setUp(
        () {
          final postController = StreamController<List<Post>>();
          when(mockGetHomePostsUseCase.stream(any))
              .thenAnswer((_) => postController.stream);
          when(mockSyncPostsUseCase.sync('address'))
              .thenAnswer((_) => Future.value(null));

          postsListBloc = PostsListBloc(
            syncPeriod: syncPeriod,
            accountBloc: mockAccountBloc,
            analytics: mockFirebaseAnalytics,
            getHomePostsUseCase: mockGetHomePostsUseCase,
            getHomeEventsUseCase: mockGetHomeEventsUseCase,
            syncPostsUseCase: mockSyncPostsUseCase,
            getNotificationsUseCase: mockGetNotificationsUseCase,
            updatePostsStatusUseCase: mockUpdatePostsStatusUseCase,
            managePostReactionsUseCase: mockManagePostReactionsUseCase,
            hidePostUseCase: mockHidePostUseCase,
            votePollUseCase: mockVotePollUseCase,
            deletePostsUseCase: mockDeletePostsUseCase,
            blockUserUseCase: mockBlockUserUseCase,
            updatePostUseCase: mockUpdatePostUseCase,
            deletePostUseCase: mockDeletePostUseCase,
            getActiveAccountUseCase: mockGetActiveAccountUseCase,
          );
        },
      );

      blocTest(
        'PostsUpdated: work properly',
        build: () {
          return postsListBloc;
        },
        act: (bloc) async {
          bloc.add(PostsUpdated(testPosts));
        },
        expect: [
          PostsLoaded(
            posts: testPosts,
            shouldRefresh: false,
            refreshing: false,
            syncingPosts: false,
            hasReachedMax: false,
          )
        ],
      );

      final likedPost = testPosts[0].copyWith(reactions: [
        Reaction(
            user: userAccount, value: Constants.LIKE_REACTION, code: '123'),
      ]);
      final expectedLikedResults = <Post>[likedPost, ...testPosts.sublist(1)];
      blocTest(
        'AddOrRemoveLiked: add work properly',
        build: () {
          return postsListBloc;
        },
        act: (bloc) async {
          when(mockManagePostReactionsUseCase.addOrRemove(
                  post: anyNamed('post'), reaction: anyNamed('reaction')))
              .thenAnswer((_) => Future.value(likedPost));
          bloc.add(PostsUpdated(testPosts));
          bloc.add(AddOrRemoveLike(testPosts[0]));
        },
        skip: 1,
        expect: [
          PostsLoaded(
            posts: expectedLikedResults,
            shouldRefresh: false,
            refreshing: false,
            syncingPosts: false,
            hasReachedMax: false,
          )
        ],
      );

      final likedTestPosts = <Post>[likedPost, ...testPosts.sublist(1)];
      blocTest(
        'AddOrRemoveLiked: remove work properly',
        build: () {
          return postsListBloc;
        },
        act: (bloc) async {
          when(mockManagePostReactionsUseCase.addOrRemove(
                  post: anyNamed('post'), reaction: anyNamed('reaction')))
              .thenAnswer((_) => Future.value(testPosts[0]));
          bloc.add(PostsUpdated(likedTestPosts));
          bloc.add(AddOrRemoveLike(testPosts[0]));
        },
        skip: 1,
        expect: [
          PostsLoaded(
            posts: testPosts,
            shouldRefresh: false,
            refreshing: false,
            syncingPosts: false,
            hasReachedMax: false,
          )
        ],
      );

      var emotionPost = testPosts[0].copyWith(reactions: [
        Reaction(
          user: userAccount,
          value: 'happy',
          code: '123',
        ),
      ]);
      var expectedReactionResults = <Post>[
        emotionPost,
        ...testPosts.sublist(1)
      ];
      blocTest(
        'AddOrRemovePostReaction: work properly',
        build: () {
          return postsListBloc;
        },
        act: (bloc) async {
          when(mockManagePostReactionsUseCase.addOrRemove(
                  post: anyNamed('post'), reaction: anyNamed('reaction')))
              .thenAnswer((_) => Future.value(emotionPost));
          bloc.add(PostsUpdated(testPosts));
          bloc.add(AddOrRemovePostReaction(testPosts[0], 'happy'));
        },
        skip: 1,
        expect: [
          PostsLoaded(
            posts: expectedReactionResults,
            shouldRefresh: false,
            refreshing: false,
            syncingPosts: false,
            hasReachedMax: false,
          )
        ],
      );

      var option = PollOption(id: 1, text: 'apples');
      var optionTwo = PollOption(id: 0, text: 'apples');
      var poll = PostPoll(
        allowsAnswerEdits: false,
        question: 'favorite snack',
        endDate: '2020-05-01T21:00:00Z',
        allowsMultipleAnswers: false,
        options: [option, optionTwo],
        userAnswers: [],
      );

      var formattedTestPoll = testPost.copyWith(poll: poll);

      var votedTestPoll = testPost.copyWith(
        poll: PostPoll(
          allowsAnswerEdits: false,
          question: 'favorite snack',
          endDate: '2020-05-01T21:00:00Z',
          allowsMultipleAnswers: false,
          options: [option, optionTwo],
          userAnswers: [
            PollAnswer(answer: 0, user: userAccount),
          ],
        ),
      );
      blocTest(
        'VotePoll: work properly',
        build: () {
          return postsListBloc;
        },
        act: (bloc) async {
          when(mockVotePollUseCase.vote(any, any))
              .thenAnswer((_) => Future.value(votedTestPoll));

          bloc.add(PostsUpdated([formattedTestPoll]));
          bloc.add(VotePoll(formattedTestPoll, option));
        },
        skip: 1,
        expect: [
          PostsLoaded(
            posts: [
              votedTestPoll,
            ],
            shouldRefresh: false,
            refreshing: false,
            syncingPosts: false,
            hasReachedMax: false,
          )
        ],
      );

      var hiddenPost = testPost.copyWith(hidden: true);
      blocTest(
        'HidePost: work properly',
        build: () {
          return postsListBloc;
        },
        act: (bloc) async {
          when(mockHidePostUseCase.hide(testPost))
              .thenAnswer((_) => Future.value(hiddenPost));

          bloc.add(PostsUpdated([testPost]));
          bloc.add(HidePost(testPost));
        },
        skip: 1,
        expect: [
          PostsLoaded(
            posts: [
              hiddenPost,
            ],
            shouldRefresh: false,
            refreshing: false,
            syncingPosts: false,
            hasReachedMax: false,
          )
        ],
      );

      final blockUser = User.fromAddress('address');
      blocTest(
        'BlockUser: work properly',
        build: () {
          return postsListBloc;
        },
        act: (bloc) async {
          when(mockBlockUserUseCase.block(any))
              .thenAnswer((_) => Future.value(null));

          bloc.add(PostsUpdated([testPost.copyWith(owner: blockUser)]));
          bloc.add(BlockUser(blockUser));
        },
        skip: 1,
        expect: [
          PostsLoaded(
            posts: [],
            shouldRefresh: false,
            refreshing: false,
            syncingPosts: false,
            hasReachedMax: false,
          )
        ],
      );

      blocTest(
        'SyncPosts: work properly',
        build: () {
          var userAccount = MooncakeAccount(
            profilePicUri: 'https://example.com/avatar.png',
            moniker: 'john-doe',
            cosmosAccount: cosmosAccount.copyWith(address: 'address'),
          );

          when(mockGetActiveAccountUseCase.single())
              .thenAnswer((_) => Future.value(userAccount));

          return postsListBloc;
        },
        act: (bloc) async {
          when(mockSyncPostsUseCase.sync('address'))
              .thenAnswer((_) => Future.value(null));
          bloc.add(PostsUpdated([testPost]));
          bloc.add(SyncPosts());
        },
        skip: 1,
        expect: [
          PostsLoaded(
            posts: [testPost],
            shouldRefresh: false,
            refreshing: false,
            syncingPosts: true,
            hasReachedMax: false,
          ),
          PostsLoaded(
            posts: [testPost],
            shouldRefresh: false,
            refreshing: false,
            syncingPosts: false,
            hasReachedMax: false,
          )
        ],
      );

      blocTest(
        'ShouldRefreshPosts: work properly',
        build: () {
          return postsListBloc;
        },
        act: (bloc) async {
          bloc.add(PostsUpdated([testPost]));
          bloc.add(ShouldRefreshPosts());
        },
        skip: 1,
        expect: [
          PostsLoaded(
            posts: [testPost],
            shouldRefresh: true,
            refreshing: false,
            syncingPosts: false,
            hasReachedMax: false,
          ),
        ],
      );

      blocTest(
        'RefreshPosts: work properly',
        build: () {
          return postsListBloc;
        },
        act: (bloc) async {
          when(mockGetHomePostsUseCase.get(
                  start: anyNamed('start'), limit: anyNamed('limit')))
              .thenAnswer((_) => Future.value(testPosts));
          bloc.add(PostsUpdated([testPost]));
          bloc.add(RefreshPosts());
        },
        skip: 1,
        expect: [
          PostsLoaded(
            posts: [testPost],
            shouldRefresh: false,
            refreshing: true,
            syncingPosts: false,
            hasReachedMax: false,
          ),
          PostsLoaded(
            posts: testPosts,
            shouldRefresh: false,
            refreshing: false,
            syncingPosts: false,
            hasReachedMax: false,
          ),
        ],
      );

      blocTest(
        'FetchPosts: work properly',
        build: () {
          return postsListBloc;
        },
        act: (bloc) async {
          when(mockGetHomePostsUseCase.get(
                  start: anyNamed('start'), limit: anyNamed('limit')))
              .thenAnswer((_) => Future.value(testPosts));
          bloc.add(FetchPosts());
        },
        expect: [
          PostsLoaded(
            posts: testPosts,
            shouldRefresh: false,
            refreshing: false,
            syncingPosts: false,
            hasReachedMax: false,
          ),
        ],
      );

      var expectedUpdatePosts = <Post>[
        testPost.copyWith(
          status: PostStatus.storedLocally(userAccount.address),
        )
      ];
      blocTest(
        'RetryPostUpload: work properly',
        build: () {
          return postsListBloc;
        },
        act: (bloc) async {
          when(mockGetActiveAccountUseCase.single())
              .thenAnswer((_) => Future.value(userAccount));
          when(mockUpdatePostUseCase.update(any))
              .thenAnswer((_) => Future.value(null));
          bloc.add(PostsUpdated([testPost]));
          bloc.add(RetryPostUpload(testPost));
        },
        expect: [
          PostsLoaded(
            posts: [testPost],
            shouldRefresh: false,
            refreshing: false,
            syncingPosts: false,
            hasReachedMax: false,
          ),
          PostsLoaded(
            posts: expectedUpdatePosts,
            shouldRefresh: false,
            refreshing: false,
            syncingPosts: false,
            hasReachedMax: false,
          )
        ],
      );

      blocTest(
        'DeletePost: work properly',
        build: () {
          return postsListBloc;
        },
        act: (bloc) async {
          when(mockDeletePostUseCase.delete(any))
              .thenAnswer((_) => Future.value(null));
          bloc.add(PostsUpdated([testPost]));
          bloc.add(DeletePost(testPost));
        },
        expect: [
          PostsLoaded(
            posts: [testPost],
            shouldRefresh: false,
            refreshing: false,
            syncingPosts: false,
            hasReachedMax: false,
          ),
          PostsLoaded(
            posts: [],
            shouldRefresh: false,
            refreshing: false,
            syncingPosts: false,
            hasReachedMax: false,
          )
        ],
      );
    },
  );
}
