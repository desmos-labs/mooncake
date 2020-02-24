import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/usecases/usecases.dart';

/// Allows to retrieve the current user of the application.
class GetUserUseCase {
  final UserRepository _userRepository;

  GetUserUseCase({@required UserRepository userRepository})
      : this._userRepository = userRepository;

  /// Returns the current user of the application.
  Future<User> get() {
    return _userRepository.getUser();
  }
}
