import 'package:mockito/mockito.dart';
import 'package:mooncake/usecases/usecases.dart';

/// Allows to easily mock a [PostsRepository] instance. We declare it
/// here so that we can re-use it inside different tests.
class PostsRepositoryMock extends Mock implements PostsRepository {}
