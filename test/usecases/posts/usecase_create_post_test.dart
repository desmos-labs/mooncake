import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/entities/account/export.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/usecases/usecases.dart';

class UserRepositoryMock extends Mock implements UserRepository {}

void main() {
  UserRepository repository;
  CreatePostUseCase createPostUseCase;

  setUp(() {
    repository = UserRepositoryMock();
    createPostUseCase = CreatePostUseCase(userRepository: repository);
  });

  group('create performs correct calls', () {
    final message = 'This is a post message';
    final allowsComments = false;
    final parentId = 'parent-id';

    test('with simple post', () async {
      final account = MooncakeAccount.local('address');
      when(repository.getActiveAccount())
          .thenAnswer((_) => Future.value(account));

      final post = await createPostUseCase.create(
        message: message,
        allowsComments: allowsComments,
        parentId: parentId,
      );

      expect(post.message, equals(message));
      expect(post.allowsComments, equals(allowsComments));
      expect(post.parentId, equals(parentId));
      expect(post.created, isNotNull);
      expect(post.owner, equals(account.toUser()));

      expect(post.medias, []);
      expect(post.poll, isNull);
    });

    test('with medias post', () async {
      final account = MooncakeAccount.local('address');
      when(repository.getActiveAccount())
          .thenAnswer((_) => Future.value(account));

      final medias = [
        PostMedia(mimeType: 'text/plain', uri: 'https://example.com/test.txt'),
        PostMedia(mimeType: 'image/png', uri: 'https://example.com/image.png'),
      ];
      final post = await createPostUseCase.create(
        message: message,
        allowsComments: allowsComments,
        parentId: parentId,
        medias: medias,
      );

      expect(post.message, equals(message));
      expect(post.allowsComments, equals(allowsComments));
      expect(post.parentId, equals(parentId));
      expect(post.medias, equals(medias));
      expect(post.created, isNotNull);
      expect(post.owner, equals(account.toUser()));
    });

    test('with poll post', () async {
      final account = MooncakeAccount.local('address');
      when(repository.getActiveAccount())
          .thenAnswer((_) => Future.value(account));

      final poll = PostPoll(
        question: 'This is a question',
        endDate: '2020-05-17T21:00:00.000Z',
        options: [
          PollOption(id: 1, text: 'Option 1'),
          PollOption(id: 2, text: 'Option 2'),
        ],
        allowsMultipleAnswers: true,
        allowsAnswerEdits: true,
      );
      final post = await createPostUseCase.create(
        message: message,
        allowsComments: allowsComments,
        parentId: parentId,
        poll: poll,
      );

      expect(post.message, equals(message));
      expect(post.allowsComments, equals(allowsComments));
      expect(post.parentId, equals(parentId));
      expect(post.poll, poll);
      expect(post.created, isNotNull);
      expect(post.owner, equals(account.toUser()));
    });
  });
}
