import 'package:mockito/mockito.dart';
import 'package:mooncake/usecases/usecases.dart';

/// Mocks the [UserRepository] interface to make tests simpler.
/// It is here because it will be used by most of the account tests and
/// we do not want to replicate code ;)
class UserRepositoryMock extends Mock implements UserRepository {}
