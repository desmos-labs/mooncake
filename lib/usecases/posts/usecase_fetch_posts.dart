import 'package:dwitter/usecases/usecases.dart';
import 'package:meta/meta.dart';

/// Allows to easily start the fetching of new posts from the chain.
class FetchPostsUseCase {
  final PostsRepository _repository;

  FetchPostsUseCase({@required PostsRepository repository})
      : assert(repository != null),
        _repository = repository;

  /// Starts the fetching of new posts from the chain.
  Future<void> fetch() {
    return _repository.fetchPosts();
  }
}
