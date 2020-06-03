import 'package:mockito/mockito.dart';
import 'package:mooncake/usecases/usecases.dart';

/// Allows to easily mock a [UsersRepository] instance
class UsersRepositoryMock extends Mock implements UsersRepository {}
