import 'dart:io';

import 'package:meta/meta.dart';
import 'package:mime_type/mime_type.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/usecases/usecases.dart';

/// Allows to create a new post.
class CreatePostUseCase {
  final UserRepository _userRepository;

  CreatePostUseCase({
    @required UserRepository walletRepository,
  })  : assert(walletRepository != null),
        _userRepository = walletRepository;

  /// Creates a new [Post] object having the given data inside.
  /// Returns the newly created object.
  Future<Post> create({
    @required String message,
    @required String parentId,
    @required bool allowsComments,
    List<File> medias,
  }) async {
    final address = await _userRepository.getAddress();
    final date = Post.getDateStringNow();

    // We perform a simple conversion to PostMedia using the File absolute
    // paths as these will need to be uploaded later
    final postMedias = medias
        ?.map((f) => PostMedia(
              url: f.absolute.path,
              mimeType: mime(f.absolute.path),
            ))
        ?.toList();

    return Post(
      id: date,
      created: date,
      parentId: parentId,
      message: message,
      allowsComments: allowsComments,
      medias: postMedias,
      subspace: Constants.SUBSPACE,
      owner: address,
    );
  }
}
