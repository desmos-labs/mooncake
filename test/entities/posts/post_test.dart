import 'package:test/test.dart';
import 'package:intl/intl.dart';
import 'package:mooncake/entities/entities.dart';

void main() {
  final stdPost = Post(
    id: '0',
    message: 'This is a test message',
    created: DateFormat(Post.DATE_FORMAT).format(DateTime.now()),
    subspace: Constants.SUBSPACE,
    owner: User.fromAddress('desmos1gxhn7cs4v3wy2z5ff296qvyd3fzggw9dkk2rmd'),
    reactions: [
      Reaction.fromValue(
        '❤',
        User.fromAddress('desmos1gxhn7cs4v3wy2z5ff296qvyd3fzggw9dkk2rmd'),
      ),
      Reaction.fromValue(
        '❤',
        User.fromAddress('desmos1gxhn7cs4v3wy2z5ff296qvyd3fzggw9dkk2rmd'),
      )
    ],
    status: PostStatus.storedLocally('address'),
  );

  test('dateTime', () {
    final dateTime = DateTime.now();
    final date = DateFormat(Post.DATE_FORMAT).format(dateTime);
    stdPost.copyWith(created: date).dateTime;
  });

  test('hasParent', () {
    expect(stdPost.copyWith(parentId: '').hasParent, isFalse);
    expect(stdPost.copyWith(parentId: null).hasParent, isFalse);
    expect(stdPost.copyWith(parentId: '1').hasParent, isTrue);
  });

  test('images', () {
    final images = [
      PostMedia(uri: 'https://example.com/1', mimeType: 'image/jpeg'),
      PostMedia(uri: 'https://example.com/2', mimeType: 'image/png'),
      PostMedia(uri: 'https://example.com/3', mimeType: 'image/gif'),
    ];
    final post = stdPost.copyWith(
      medias: images +
          [PostMedia(uri: 'https://example.com/4', mimeType: 'text/plain')],
    );
    expect(post.medias, hasLength(4));
    expect(post.images, equals(images));
  });

  test('likes', () {
    expect(stdPost.likes.length, 1);
  });
}
