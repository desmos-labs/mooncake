import 'package:meta/meta.dart';
import 'package:mooncake/usecases/usecases.dart';

/// Allows to get all the events that should require the user to refresh
/// the home screen of the application.
class GetHomeEventsUseCase {
  final PostsRepository _postsRepository;

  GetHomeEventsUseCase({
    @required PostsRepository postsRepository,
  })  : assert(postsRepository != null),
        _postsRepository = postsRepository;

  /// Returns a [Stream] emitting a new item each time that a new event
  /// that should require the user to refresh the home page is emitted.
  Stream<dynamic> get stream {
    return _postsRepository.homeEventsStream;
  }
}
